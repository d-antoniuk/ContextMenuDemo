#include "device_model.h"

#include <QTimer>
#include <utility>

namespace {
const QHash<int, QByteArray> kRoleNames { { DeviceModel::NameRole, "name" },
    { DeviceModel::VersionRole, "version" } };
}

void DeviceClient::fetchDevices(DeviceClient::Callback cb) const
{
    QTimer::singleShot(3000, [cb = std::move(cb)]() {
        QVector<Device> devices { { "Name1", "Version1" }, { "Name2", "Version2" }, { "Name3", "Version3" } };

        cb(std::error_code {}, devices);
    });
}

DeviceModel::DeviceModel(DeviceClient* client, QObject* parent)
    : QAbstractTableModel(parent)
    , m_client(client)
{
    fetchDevices();
}

int DeviceModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;

    return m_devices.size();
}

int DeviceModel::columnCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;

    return kRoleNames.size();
}

QVariant DeviceModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_devices.size())
        return {};

    const Device& device = m_devices.at(index.row());

    switch (role) {
    case NameRole:
        return device.name;
    case VersionRole:
        return device.version;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> DeviceModel::roleNames() const
{
    return kRoleNames;
}

void DeviceModel::reload()
{
    fetchDevices();
}

void DeviceModel::setState(DeviceModel::State state)
{
    if (m_state == state)
        return;

    m_state = state;
    emit stateChanged();
}

void DeviceModel::setStatusMessage(const QString& message)
{
    if (m_statusMessage == message)
        return;

    m_statusMessage = message;
    emit statusMessageChanged();
}

void DeviceModel::fetchDevices()
{
    auto updateDevices = [this](QVector<Device> devices) {
        beginResetModel();
        m_devices = std::move(devices);
        endResetModel();
    };

    if (!m_client) {
        setState(State::Error);
        setStatusMessage(QStringLiteral("No client configured"));
        updateDevices({});
        return;
    }

    setState(State::Pending);
    setStatusMessage(QStringLiteral("Loading devices..."));
    updateDevices({});

    m_client->fetchDevices([this, updateDevices](std::error_code ec, QVector<Device> devices) {
        if (ec) {
            setState(State::Error);
            setStatusMessage(QStringLiteral("Failed to load devices"));
            updateDevices({});
            return;
        }

        setState(State::Ready);
        setStatusMessage(QString());
        updateDevices(std::move(devices));
    });
}
