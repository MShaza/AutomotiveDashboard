#ifndef DASHBOARDDATA_H
#define DASHBOARDDATA_H

#include <QObject>

class DashboardData : public QObject {
    Q_OBJECT
    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(float rpm READ rpm WRITE setRpm NOTIFY rpmChanged)
    Q_PROPERTY(int fuelLevel READ fuelLevel WRITE setFuelLevel NOTIFY fuelLevelChanged)
    Q_PROPERTY(bool indicatorOn READ indicatorOn WRITE setIndicatorOn NOTIFY indicatorOnChanged)

public:
    explicit DashboardData(QObject *parent = nullptr);

    int speed() const;
    void setSpeed(int value);

    float rpm() const;
    void setRpm(float value);

    int fuelLevel() const;
    void setFuelLevel(int value);

    bool indicatorOn() const;
    void setIndicatorOn(bool value);

signals:
    void speedChanged();
    void rpmChanged();
    void fuelLevelChanged();
    void indicatorOnChanged();

private:
    int m_speed = 0;
    float m_rpm = 0.0f;
    int m_fuelLevel = 100;
    bool m_indicatorOn = false;
};

#endif // DASHBOARDDATA_H
