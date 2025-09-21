cmake_minimum_required(VERSION 3.16)

project(AutomotiveDashboard VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find Qt6
find_package(Qt6 6.2 REQUIRED COMPONENTS Core Gui Quick Qml)

# Sources
set(SOURCES
    main.cpp
    c++/src/dashboarddata.cpp
)

set(HEADERS
    c++/include/dashboarddata.h
)

set(APP_NAME AutomotiveDashboard_app)

qt_add_executable(${APP_NAME}
    ${SOURCES}
    ${HEADERS}
)

# Register QML module (this replaces qml.qrc in Qt6)
file(GLOB ICON_FILES resources/icons/*.*)

qt_add_qml_module(${APP_NAME}
    URI AutomotiveDashboard
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/components/BarIndicator.qml
        qml/components/Speedometer.qml
        themes/DarkTheme.qml
        themes/LightTheme.qml
    RESOURCES
        ${ICON_FILES}
)

target_include_directories(${APP_NAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/c++/include
)

target_link_libraries(${APP_NAME}
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Quick
        Qt6::Qml
)

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)
