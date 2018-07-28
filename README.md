# swams-client
Android client for the SWAMS firmware written in Qt 5 and QtQuick. This application will communicate via bluetooth to the SWAMS firmware installed on the host AVR machine.

See [SWAMS](http://github.com/argarak/swams) for the fimware.

## Features

* Real-time monitoring of temperature, PH and other water factors
* Setting of hardware RTC present and making sure it is up to date
* Setting lighting rules which allow LED lights to gradually switch on/off depending on the current time
* Alarms when water level is too high/low and when the temperature is too high/low (can be changed in settings)
