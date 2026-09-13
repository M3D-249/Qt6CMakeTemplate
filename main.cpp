#include <iostream>
#include <qapplication.h>
#include <qlabel.h>
#include <Version.h>
#include <qboxlayout.h>
#include <qwidget.h>

int main(int argc, char** argv)
{
    QApplication app(argc, argv);

    QWidget window;
    window.resize(520, 300);

    QString msg = "YOU DID IT! \n app-version: ";
    msg += QT6CMAKETEMPLATE_VERSION;
    
    QLabel lbl(msg);
    lbl.setStyleSheet("color: #efh765; font-size: 40px;");

    QVBoxLayout layout(&window);
    layout.addWidget(&lbl, 0, Qt::AlignHCenter);

    window.show();

    return app.exec();
}