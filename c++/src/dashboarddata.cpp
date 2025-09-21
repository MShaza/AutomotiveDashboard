#include "dashboarddata.h"
#include <QtGlobal> 

DashboardData::DashboardData(QObject *parent)
    : QObject(parent) {}

int DashboardData::speed() const {
    return m_speed;
}

void DashboardData::setSpeed(int value) {
    if (m_speed != value) {
        m_speed = value;
        emit speedChanged();
    }
}

float DashboardData::rpm() const {
    return m_rpm;
}

void DashboardData::setRpm(float value) {
    if (!qFuzzyCompare(m_rpm, value)) {
        m_rpm = value;
        emit rpmChanged();
    }
}

int DashboardData::fuelLevel() const {
    return m_fuelLevel;
}

void DashboardData::setFuelLevel(int value) {
    if (m_fuelLevel != value) {
        m_fuelLevel = value;
        emit fuelLevelChanged();
    }
}

bool DashboardData::indicatorOn() const {
    return m_indicatorOn;
}

void DashboardData::setIndicatorOn(bool value) {
    if (m_indicatorOn != value) {
        m_indicatorOn = value;
        emit indicatorOnChanged();
    }
}
