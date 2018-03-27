/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function getDeviceID() {
    if (localStorage['deviceID'] === "null" || localStorage['deviceID'] === undefined) {
        setDeviceID();
    }
    return localStorage['deviceID'];
}

function setDeviceID() {
    localStorage['deviceID'] = Math.random();
    getLocation(sendDeviceID);
}

function sendDeviceID(lat, long) {
    var postString = "deviceToken=" + localStorage['deviceID'] +
            "&latitude=" + lat
            + "&longitude=" + long;
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Notifications/recieveDeviceID.php";
    var responseFunction = function (data, status) {
    };
    $.post(URL, postString, responseFunction);
}
