#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <qqml.h>

#include "device_model.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    DeviceClient client;
    DeviceModel deviceModel(&client);

    qmlRegisterUncreatableType<DeviceModel>("ContextMenu", 1, 0, "DeviceModel", "Enums only");

    engine.rootContext()->setContextProperty("deviceModel", &deviceModel);

    engine.load(QUrl(QStringLiteral("qrc:/ContextMenu/qml/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
