cmake_minimum_required(VERSION 3.1)

# Project setup
project(AutomotiveDashboard VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Qt5
find_package(Qt5 5.15 REQUIRED COMPONENTS Quick Qml)

# Source files
set(SOURCES
    main.cpp
)

# QML + resource files (for now, just placeholders)
set(QML_FILES
    qml/Main.qml
    themes/DarkTheme.qml
    themes/LightTheme.qml
)

# Bundle QML into resources (Qt5 uses qrc for deployment)
qt5_add_resources(QT_RESOURCES
    qml.qrc
)

# Define executable
add_executable(${PROJECT_NAME}
    ${SOURCES}
    ${QT_RESOURCES}
)

# Link with Qt5
target_link_libraries(${PROJECT_NAME}
    PRIVATE Qt5::Quick Qt5::Qml
)
