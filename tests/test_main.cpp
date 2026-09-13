#include <QTest>
#include <QLabel>

class SimpleTest : public QObject
{
    Q_OBJECT

private slots:
    void buttonTest()
    {
        QLabel lbl("Hi!");
        QCOMPARE(lbl.text(), QString("Hi!"));
        QVERIFY(!lbl.isVisible());
    }
};

QTEST_MAIN(SimpleTest)
#include "test_main.moc"