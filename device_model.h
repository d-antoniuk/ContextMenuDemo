#pragma once

#include <QAbstractTableModel>
#include <QString>
#include <QVector>
#include <functional>
#include <system_error>

struct Device {
    QString name;
    QString version;
};

class DeviceClient {
public:
    using Callback = std::function<void(std::error_code, QVector<Device>)>;

    void fetchDevices(Callback cb) const;
};

class DeviceModel : public QAbstractTableModel {
    Q_OBJECT

public:
    enum State { Ready = 0,
        Pending,
        Error };
    Q_ENUM(State)

    Q_PROPERTY(State state READ state NOTIFY stateChanged)
    Q_PROPERTY(QString statusMessage READ statusMessage NOTIFY statusMessageChanged)

    enum Roles { NameRole = Qt::UserRole + 1,
        VersionRole };

    DeviceModel(DeviceClient* client, QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    int columnCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void reload();

    State state() const { return m_state; }
    QString statusMessage() const { return m_statusMessage; }

signals:
    void stateChanged();
    void statusMessageChanged();

private:
    void setState(State state);
    void setStatusMessage(const QString& message);
    void fetchDevices();

    QVector<Device> m_devices;
    DeviceClient* m_client { nullptr };
    State m_state { Ready };
    QString m_statusMessage;
};
