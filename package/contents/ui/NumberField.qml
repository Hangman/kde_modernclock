import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

RowLayout {
    id: numberField
    property alias label: numberField_label.text;
    property alias value: numberField_spinbox.value

    Label {
        id: numberField_label
    }
    SpinBox {
        id: numberField_spinbox
        from: 1
        to: 999
        stepSize: 1
        editable: true
        wheelEnabled: false
    }
}
