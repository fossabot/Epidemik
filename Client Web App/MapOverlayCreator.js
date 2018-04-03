/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/* global google */
var splits;
var diseases = [];
var numXY = 20;
var latLongDisease;
var allRects = [];

function getData(map) {
    // Sending and receiving data in JSON format using POST method
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getCurrentData.php";
    var post = "get=true";
    var responseFunction = function (data, status) {
        processText(data, map);
    };
    $.post(URL, post, responseFunction);
}

function addOverlays(map) {
    var bounds = map.getBounds();
    if(bounds === undefined) {
        return;
    }
    var ne = bounds.getNorthEast(); // LatLng of the north-east corner
    var sw = bounds.getSouthWest(); // LatLng of the south-west corder
    var startLat = sw.lat();
    var startLong = sw.lng();
    var averageIntensity = 1.0;
    var latWidth = Math.abs(sw.lat() - ne.lat());
    var longWidth = Math.abs(sw.lng() - ne.lng());
    //map.removeOverlays(map.overlays)
    this.latLongDisease = [[]];
    for (var i = 0; i < 100; i++) {
        this.latLongDisease.push([]);
        for (var i2 = 0; i2 < 100; i2++) {
            this.latLongDisease[i].push("");
        }
    }
    var realPointCounts = 1.0;
    var intervalLat = latWidth / numXY;
    var intervalLong = longWidth / numXY;
    for (const i in this.diseases) {
        var data = this.diseases[i];
        var deltaLat = data.lat - startLat;
        let deltaLong = data.long - startLong;
        if (deltaLong > 0 && deltaLat > 0 && deltaLat < latWidth && deltaLong < longWidth) {
            var posnLat = (Math.floor(deltaLat / (latWidth / numXY)));
            var posnLong = (Math.floor(deltaLong / (longWidth / numXY)));
            var realLat = (posnLat) * intervalLat + startLat;
            var realLong = (posnLong) * intervalLong + startLong;
            var scaleLat = latWidth / numXY;
            var scaleLong = longWidth / numXY;
            var bounds = {
                north: realLat + scaleLat,
                south: realLat,
                east: realLong + scaleLong,
                west: realLong
            };
            if (posnLat >= this.latLongDisease.length || posnLong >= this.latLongDisease[posnLat].length) {
                continue;
            }
            if (this.latLongDisease[posnLat][posnLong] === "") {
                this.latLongDisease[posnLat][posnLong] = new DiseasePolygon(bounds, 0);
                realPointCounts += 1;
            }
            averageIntensity += 1;
            this.latLongDisease[posnLat][posnLong].addIntensity();
        }
    }
    averageIntensity /= realPointCounts;
    map.totalOverlays = (realPointCounts);
    clearOverlays(map);
    for (const x in this.latLongDisease) {
        for (const y in this.latLongDisease[x]) {
            if (this.latLongDisease[x][y] !== "") {
                var power = (this.latLongDisease[x][y].intensity / averageIntensity);
                var toAdd = new google.maps.Rectangle({
                    bounds: this.latLongDisease[x][y].bounds,
                    editable: false,
                    strokeColor: '#FF0000',
                    strokeOpacity: 2 / 4 * power,
                    strokeWeight: 2,
                    fillColor: '#FF0000',
                    fillOpacity: 1 / 4 * power,
                    map: this.map
                });
                this.allRects.push(toAdd);
            }
        }
    }
}

function processText(text, map) {
    this.splits = text.split("\n");
    for (const i in splits) {
        var parts = splits[i].split(",");
        if (parts.length < 1) {
            break;
        }
        var newDisease = new Disease(parts[0], parts[1]);
        this.diseases.push(newDisease);
    }
    addOverlays(map);
}

function clearOverlays(map) {
    for (const x in this.allRects) {
        if (this.allRects[x] !== "") {
            allRects[x].setMap(null);
        }
    }
}
