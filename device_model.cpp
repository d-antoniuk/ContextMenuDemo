#include "device_model.h"

#include <QTimer>
#include <utility>

void DeviceClient::fetchDevices(DeviceClient::Callback cb) const
{
    QTimer::singleShot(3000, [cb = std::move(cb)]()
                       {
        QVector<Device> devices {
            { "Name1", "Version1" },
            { "Name2", "Version2" },
            { "Name3", "Version3" }
        };

        cb(std::error_code {}, devices); });
}

DeviceModel::DeviceModel(DeviceClient *client, QObject *parent)
    : QAbstractTableModel(parent), m_client(client)
{
    fetchDevices();
}

int DeviceModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_devices.size();
}

int DeviceModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return ColumnCount;
}

QVariant DeviceModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (index.row() < 0 || index.row() >= m_devices.size())
        return QVariant();

    const Device &device = m_devices.at(index.row());

    switch (role)
    {
    case Qt::DisplayRole:
        switch (index.column())
        {
        case NameColumn:
            return device.name;
        case VersionColumn:
            return device.version;
        default:
            return QVariant();
        }
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
    return {
        {NameRole, "name"},
        {VersionRole, "version"}};
}

QVariant DeviceModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (orientation == Qt::Horizontal && role == Qt::DisplayRole)
    {
        switch (section)
        {
        case NameColumn:
            return QStringLiteral("Name");
        case VersionColumn:
            return QStringLiteral("Version");
        default:
            break;
        }
    }

    return QVariant();
}

QVariantMap DeviceModel::deviceAt(int row) const
{
    QVariantMap map;
    if (row < 0)
        return map;

    if (m_state != State::Ready)
        return map;

    if (row >= m_devices.size())
        return map;

    const Device &device = m_devices.at(row);
    map.insert("name", device.name);
    map.insert("version", device.version);
    return map;
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

void DeviceModel::setStatusMessage(const QString &message)
{
    if (m_statusMessage == message)
        return;

    m_statusMessage = message;
    emit statusMessageChanged();
}

void DeviceModel::fetchDevices()
{
    if (!m_client)
    {
        setState(State::Error);
        setStatusMessage(QStringLiteral("No client configured"));
        beginResetModel();
        m_devices.clear();
        endResetModel();
        return;
    }

    setState(State::Pending);
    setStatusMessage(QStringLiteral("Loading devices..."));

    beginResetModel();
    m_devices.clear();
    endResetModel();

    m_client->fetchDevices([this](std::error_code ec, QVector<Device> devices)
                           {
        if (ec) {
            setState(State::Error);
            setStatusMessage(QStringLiteral("Failed to load devices"));

            beginResetModel();
            m_devices.clear();
            endResetModel();
            return;
        }

        setState(State::Ready);
        setStatusMessage(QString());

        beginResetModel();
        m_devices = std::move(devices);
        endResetModel(); });
}
