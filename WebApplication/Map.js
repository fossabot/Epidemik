/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/* global google */

function initMap() {
    var uluru = {lat: 42.4706918, lng: -71.0628642};
    this.map = new google.maps.Map(document.getElementById('map'), {
        zoom: 5,
        center: uluru,
        minZoom: 5,
        maxZoom: 15,
        disableDefaultUI: true
    });
    this.map.addListener('bounds_changed', function () {
        clearOverlays(map);
        addOverlays(map);
    });
    getData(this.map);
}

function addOverlay() {
    var rectangle = new google.maps.Rectangle({
        bounds: this.bounds,
        editable: false,
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0.1,
        map: this.map
    });
}

