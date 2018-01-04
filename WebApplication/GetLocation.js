/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var responseFunc;

function getLocation(responseFunc) {
    this.responseFunc = responseFunc;
    if (localStorage['lat'] !== null && localStorage['lat'] !== "null" && localStorage['lat'] !== undefined) {
        responseFunc(localStorage['lat'], localStorage['long']);
    } else {
        if ("geolocation" in navigator) {
            navigator.geolocation.getCurrentPosition(setLocation, handleError);
        }
    }
}

function setLocation(location) {
    localStorage['lat'] = location.coords.latitude;
    localStorage['long'] = location.coords.longitude;
    this.responseFunc(location.coords.latitude, location.coords.longitude);
}

function handleError(error) {

}


