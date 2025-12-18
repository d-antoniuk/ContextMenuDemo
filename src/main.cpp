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

    qmlRegisterUncreatableType<DeviceModel>("DemoApp", 1, 0, "DeviceModel", "Enums only");

    engine.rootContext()->setContextProperty("deviceModel", &deviceModel);

    engine.loadFromModule("DemoApp", "Main");
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
