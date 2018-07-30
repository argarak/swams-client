#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtCore/QDir>
#include <QtQml/QQmlEngine>

#include <QApplication>
#include <QQmlApplicationEngine>

#include <QDebug>
#include <QBluetoothLocalDevice>
#include <QtCore/QLoggingCategory>

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QtAndroid>
#endif

#ifdef Q_OS_ANDROID
#include <QtSvg>
#endif

int main(int argc, char *argv[]) {
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling); // DPI support

    QApplication app(argc, argv);

    QList<QBluetoothHostInfo> infos = QBluetoothLocalDevice::allDevices();
    if (infos.isEmpty())
        qWarning() << "Missing Bluetooth local device. "
                      "Example will not work properly.";

    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
