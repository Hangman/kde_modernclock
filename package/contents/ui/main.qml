import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root

    function resolvedFontFamily(configuredFamily, fallbackFamily) {
        var family = (configuredFamily || "").trim()
        return family.length > 0 ? family : fallbackFamily
    }

    function resolvedDateLocale(configuredLocale) {
        var localeCode = (configuredLocale || "").trim()
        return localeCode.length > 0 ? Qt.locale(localeCode) : Qt.locale()
    }

    function applyDayCase(dayText, configuredCase) {
        var dayCase = (configuredCase || "default").trim()
        if (dayCase === "upper") {
            return dayText.toLocaleUpperCase()
        }
        if (dayCase === "lower") {
            return dayText.toLocaleLowerCase()
        }
        if (dayCase === "capitalized") {
            var normalized = dayText.toLocaleLowerCase()
            if (normalized.length === 0) {
                return normalized
            }
            return normalized.charAt(0).toLocaleUpperCase() + normalized.slice(1)
        }
        return dayText
    }

    // setting background as transparent with a drop shadow
    Plasmoid.backgroundHints: PlasmaCore.Types.ShadowBackground | PlasmaCore.Types.ConfigurableBackground
    
    // loading fonts
    FontLoader {
        id: font_anurati
        source: "../fonts/Anurati.otf"
    }
    FontLoader {
        id: font_poppins
        source: "../fonts/Poppins.ttf"
    }
    

    // setting preferred size
    preferredRepresentation: fullRepresentation
    fullRepresentation: Item {
        function updateDisplay() {
            var time_format = plasmoid.configuration.use_24_hour_format ? "HH:mm" : "hh:mm AP"
            var curDate = new Date()
            var styleCharacter = (plasmoid.configuration.time_character || "").trim().slice(0, 1)
            var formattedTime = Qt.formatTime(curDate, time_format)
            var dateLocale = root.resolvedDateLocale(plasmoid.configuration.date_locale)

            display_day.text = root.applyDayCase(dateLocale.toString(curDate, "dddd"), plasmoid.configuration.day_case)
            display_date.text = dateLocale.toString(curDate, plasmoid.configuration.date_format)
            display_time.text = styleCharacter.length > 0
                ? styleCharacter + " " + formattedTime + " " + styleCharacter
                : formattedTime
            display_day.font.family = root.resolvedFontFamily(plasmoid.configuration.day_font_family, font_anurati.name)
            display_date.font.family = root.resolvedFontFamily(plasmoid.configuration.date_font_family, font_poppins.name)
            display_time.font.family = root.resolvedFontFamily(plasmoid.configuration.time_font_family, font_poppins.name)
        }

        function startMinuteUpdates() {
            var now = new Date()
            alignToMinuteTimer.interval = Math.max(1000, ((60 - now.getSeconds()) * 1000) - now.getMilliseconds())
            alignToMinuteTimer.start()
        }

        // applet default size
        Layout.minimumWidth: container.implicitWidth
        Layout.minimumHeight: container.implicitHeight
        Layout.preferredWidth: Layout.minimumWidth
        Layout.preferredHeight: Layout.minimumHeight

        // Align to the next minute once, then update every minute.
        Timer {
            id: alignToMinuteTimer
            repeat: false
            onTriggered: {
                updateDisplay()
                minuteTimer.start()
            }
        }

        Timer {
            id: minuteTimer
            interval: 60000
            repeat: true
            running: false
            onTriggered: updateDisplay()
        }

        Connections {
            target: plasmoid.configuration
            function onValueChanged(key, value) {
                if (key === "day_font_family" || key === "date_font_family" || key === "time_font_family" ||
                    key === "date_format" || key === "date_locale" || key === "day_case" || key === "time_character" || key === "use_24_hour_format") {
                    updateDisplay()
                }
            }
        }

        Component.onCompleted: {
            updateDisplay()
            startMinuteUpdates()
        }

        // Main Content
        Column {
            id: container

            // Column settings
            anchors.centerIn: parent
            spacing: 5

            // The day ("Tuesday", "Wednesday" etc..)
            PlasmaComponents.Label {
                id: display_day
                
                // visible
                visible: plasmoid.configuration.show_day

                // font settings
                font.pixelSize: plasmoid.configuration.day_font_size
                font.letterSpacing: plasmoid.configuration.day_letter_spacing
                color: plasmoid.configuration.day_font_color
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: font.letterSpacing / 2
                horizontalAlignment: Text.AlignHCenter 
            }

            // The Date
            PlasmaComponents.Label {
                id: display_date

                // visibility
                visible: plasmoid.configuration.show_date

                // font settings
                font.pixelSize: plasmoid.configuration.date_font_size
                font.letterSpacing: plasmoid.configuration.date_letter_spacing
                color: plasmoid.configuration.date_font_color
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: font.letterSpacing / 2
            }

            // The Time
            PlasmaComponents.Label {
                id: display_time

                // visibility
                visible: plasmoid.configuration.show_time

                // font settings
                font.pixelSize: plasmoid.configuration.time_font_size
                color: plasmoid.configuration.time_font_color
                font.letterSpacing: plasmoid.configuration.time_letter_spacing
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: font.letterSpacing / 2
            }
        }
    }
}
