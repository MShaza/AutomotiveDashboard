#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTimer>            
#include "dashboarddata.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    DashboardData dashboard;

    QTimer timer;
    QObject::connect(&timer, &QTimer::timeout, [&]() {
        static int s = 0;
        s = (s + 5) % 180;  // cycle speed
        dashboard.setSpeed(s);

        float rpm = (s % 90) / 10.0f;  // fake rpm
        dashboard.setRpm(rpm);

        int fuel = 100 - (s % 100);    // fake fuel level
        dashboard.setFuelLevel(fuel);
    });
    timer.start(500);

   
    engine.rootContext()->setContextProperty("dashboardData", &dashboard);

    
    engine.loadFromModule("AutomotiveDashboard", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
