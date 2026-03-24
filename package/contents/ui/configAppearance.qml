import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.20 as Kirigami

Kirigami.ScrollablePage {
    id: appearancePage
    property var activeFontField
    
    // properties
    property alias cfg_day_case: dayCaseCode.text
    property alias cfg_show_day: showDay.checked
    property alias cfg_show_date: showDate.checked
    property alias cfg_show_time: showTime.checked
    property alias cfg_day_font_size: dayFontSize.value
    property alias cfg_day_font_family: dayFontFamily.text
    property alias cfg_date_font_size: dateFontSize.value
    property alias cfg_date_font_family: dateFontFamily.text
    property alias cfg_time_font_size: timeFontSize.value
    property alias cfg_time_font_family: timeFontFamily.text
    property alias cfg_day_letter_spacing: dayLetterSpacing.value
    property alias cfg_day_font_color: dayFontColor.color
    property alias cfg_date_letter_spacing: dateLetterSpacing.value
    property alias cfg_time_letter_spacing: timeLetterSpacing.value
    property alias cfg_time_font_color: timeFontColor.color
    property alias cfg_use_24_hour_format: use24HourFormat.checked
    property alias cfg_time_character: timeCharacter.text
    property alias cfg_date_format: dateFormat.text
    property alias cfg_date_locale: dateLocaleCode.text
    property alias cfg_date_font_color: dateFontColor.color

    property var dateLocaleOptions: [
        { text: i18n("System language"), value: "" },
        { text: "Deutsch", value: "de_DE" },
        { text: "English (US)", value: "en_US" },
        { text: "Español", value: "es_ES" },
        { text: "Français", value: "fr_FR" },
        { text: "Italiano", value: "it_IT" },
        { text: "Nederlands", value: "nl_NL" },
        { text: "Polski", value: "pl_PL" },
        { text: "Português (Brasil)", value: "pt_BR" },
        { text: "Русский", value: "ru_RU" },
        { text: "Türkçe", value: "tr_TR" },
        { text: "中文 (简体)", value: "zh_CN" },
        { text: "日本語", value: "ja_JP" }
    ]

    property var dayCaseOptions: [
        { text: i18n("Default"), value: "default" },
        { text: i18n("UPPER CASE"), value: "upper" },
        { text: i18n("lower case"), value: "lower" },
        { text: i18n("Capitalized"), value: "capitalized" }
    ]

    function updateDateLocaleSelection() {
        var localeCode = (dateLocaleCode.text || "").trim()
        var selectedIndex = 0

        for (var i = 0; i < dateLocaleOptions.length; i++) {
            if (dateLocaleOptions[i].value === localeCode) {
                selectedIndex = i
                break
            }
        }

        dateLocale.currentIndex = selectedIndex
    }

    function updateDayCaseSelection() {
        var dayCase = (dayCaseCode.text || "default").trim()
        var selectedIndex = 0

        for (var i = 0; i < dayCaseOptions.length; i++) {
            if (dayCaseOptions[i].value === dayCase) {
                selectedIndex = i
                break
            }
        }

        dayCase.currentIndex = selectedIndex
    }

    function openFontPicker(targetField, dialogTitle) {
        activeFontField = targetField
        fontPicker.title = dialogTitle
        var availableFonts = Qt.fontFamilies()
        fontFamilyCombo.model = availableFonts
        var selectedIndex = 0
        for (var i = 0; i < availableFonts.length; i++) {
            if (availableFonts[i] === targetField.text) {
                selectedIndex = i
                break
            }
        }
        fontFamilyCombo.currentIndex = selectedIndex
        fontPicker.open()
    }

    Kirigami.FormLayout {
        Title {
            title: i18n("General Settings")
        }
        RowLayout {
            Label {
                text: i18n("Date language")
            }
            ComboBox {
                id: dateLocale
                Layout.fillWidth: true
                textRole: "text"
                model: dateLocaleOptions
                onActivated: dateLocaleCode.text = dateLocaleOptions[currentIndex].value
                Component.onCompleted: appearancePage.updateDateLocaleSelection()

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    onWheel: function(wheel) { wheel.accepted = true }
                }
            }
        }
        TextField {
            id: dateLocaleCode
            visible: false
            text: ""
            onTextChanged: appearancePage.updateDateLocaleSelection()
        }
        Label {
            text: i18n("Select the language used for weekday and month names. System language is used by default.")
            color: Kirigami.Theme.disabledTextColor
            font.pixelSize: Kirigami.Theme.smallFont.pixelSize
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        Title {
            title: i18n("Day")
        }
        RowLayout {
            Label {
                text: i18n("Show Day")
            }
            CheckBox {
                id: showDay
            }
        }
        RowLayout {
            Label {
                text: i18n("Text case")
            }
            ComboBox {
                id: dayCase
                Layout.fillWidth: true
                textRole: "text"
                model: dayCaseOptions
                onActivated: dayCaseCode.text = dayCaseOptions[currentIndex].value
                Component.onCompleted: appearancePage.updateDayCaseSelection()

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    onWheel: function(wheel) { wheel.accepted = true }
                }
            }
        }
        TextField {
            id: dayCaseCode
            visible: false
            text: "default"
            onTextChanged: appearancePage.updateDayCaseSelection()
        }
        NumberField {
            id: dayFontSize
            label: i18n("Font Size")
        }
        RowLayout {
            Label {
                text: i18n("Font Family")
            }
            TextField {
                id: dayFontFamily
                readOnly: true
                Layout.fillWidth: true
            }
            Button {
                text: i18n("Choose…")
                onClicked: appearancePage.openFontPicker(dayFontFamily, i18n("Select day font"))
            }
        }
        NumberField {
            id: dayLetterSpacing
            label: i18n("Letter Spacing")
        }
        ColorDial {
            id: dayFontColor
            color: cfg_day_font_color
        }
        Title {
            title: i18n("Date")
        }
        RowLayout {
            Label {
                text: i18n("Show Date")
            }
            CheckBox {
                id: showDate
            }
        }
        NumberField {
            id: dateFontSize
            label: i18n("Font Size")
        }
        RowLayout {
            Label {
                text: i18n("Font Family")
            }
            TextField {
                id: dateFontFamily
                readOnly: true
                Layout.fillWidth: true
            }
            Button {
                text: i18n("Choose…")
                onClicked: appearancePage.openFontPicker(dateFontFamily, i18n("Select date font"))
            }
        }
        NumberField {
            id: dateLetterSpacing
            label: i18n("Letter Spacing")
        }
        RowLayout {
            Label {
                text: i18n("Date format")
            }
            TextField {
                id: dateFormat
                Layout.fillWidth: true
                placeholderText: i18n("e.g. dd MMM yyyy")
                selectByMouse: true
            }
        }
        Label {
            text: i18n("Uses Qt date format patterns (example: dddd, dd MMM yyyy).")
            color: Kirigami.Theme.disabledTextColor
            font.pixelSize: Kirigami.Theme.smallFont.pixelSize
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
        ColorDial {
            id: dateFontColor
            color: cfg_date_font_color
        }

        Title {
            title: i18n("Time")
        }
        RowLayout {
            Label {
                text: i18n("Show Time")
            }
            CheckBox {
                id: showTime
            }
        }
        NumberField {
            id: timeFontSize
            label: i18n("Font Size")
        }
        RowLayout {
            Label {
                text: i18n("Font Family")
            }
            TextField {
                id: timeFontFamily
                readOnly: true
                Layout.fillWidth: true
            }
            Button {
                text: i18n("Choose…")
                onClicked: appearancePage.openFontPicker(timeFontFamily, i18n("Select time font"))
            }
        }
        NumberField {
            id: timeLetterSpacing
            label: i18n("Letter Spacing")
        }
        RowLayout {
            Label {
                text: i18n("Use 24 hour format")
            }
            CheckBox {
                id: use24HourFormat
                ToolTip.visible: hovered
                ToolTip.text: i18n("Enabled: 00–23, disabled: 01–12 AM/PM")
            }
        }
        RowLayout {
            Label {
                text: i18n("Style Character")
            }
            TextField {
                id: timeCharacter
                maximumLength: 1
                placeholderText: "-"
                selectByMouse: true
            }
        }
        Label {
            text: i18n("Optional character shown before and after the time.")
            color: Kirigami.Theme.disabledTextColor
            font.pixelSize: Kirigami.Theme.smallFont.pixelSize
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
        ColorDial {
            id: timeFontColor
            color: cfg_time_font_color
        }
    }

    Dialog {
        id: fontPicker
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        width: 400

        contentItem: ColumnLayout {
            spacing: Kirigami.Units.smallSpacing

            Label {
                text: i18n("Choose an installed font family")
            }

            ComboBox {
                id: fontFamilyCombo
                Layout.fillWidth: true
            }
        }

        onAccepted: {
            if (activeFontField) {
                activeFontField.text = fontFamilyCombo.currentText
            }
        }
    }
}
