.pragma library

var globalTime = new Date();
var globalTemp = 0.0
var globalPH = 0.0

var data = {
    "ph": 0.0,
    "temp": 0.0,
    "date": new Date(),
    "offset": 0,
    "version": "1.0.0"
}

function convertFromUART(rawData) {
    if(rawData.startsWith("Time")) {
        var splitData = rawData.split(" ");

        var time = splitData[1].split(":");

        var date = splitData[5].split("/");

        globalTime = new Date(parseInt(date[2]), parseInt(date[1]) - 1,
                              parseInt(date[0]), parseInt(time[0]),
                              parseInt(time[1]), parseInt(time[0]), 0)

    } else if(rawData.startsWith("Temp")) {
        var splitTempData = rawData.split(" ");
        console.log(splitTempData[1]);

        globalTemp = parseInt(splitTempData[1]) * 0.0625;
        console.log(globalTemp);

    } else if(rawData.startsWith("ADC")) {
        var splitADCData = rawData.split(" ");

        globalPH = (5.22833 - (parseInt(splitADCData[1]) * (5.0 / 1023.0))) / 0.365;
        console.log(globalPH);

    }
}

function updateData(ph, temp, time) {
    ph = globalPH;
    temp = globalTemp;
    time = globalTime.toLocaleString('en-GB');
}
