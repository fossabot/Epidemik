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
    getDeviceIDPOST();
}

function sendDevPOST(toSend) {
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Notifications/recieveDeviceID.php";
    alert(URL);
    var responseFunction = function (data, status) {
    };
    $.post(URL, toSend, responseFunction);
}

function getDeviceIDPOST() {
    alert(localStorage['lat']);
    if (localStorage['lat'] !== null && localStorage['lat'] !== "null" && localStorage['lat'] !== undefined) {
        var postString = "deviceToken=" + localStorage['deviceID'] + "&latitude=" + localStorage['lat'] + "&longitude=" + localStorage['long'];
        sendDevPOST(postString);
    } else {
        navigator.geolocation.getCurrentPosition(sendDeviceID, handleError);
    }
}

function sendDeviceID(location) {
    var postString = "deviceToken=" + localStorage['deviceID'] +
            "&latitude=" + location.coords.latitude
            + "&longitude=" + location.coords.longitude;
    sendDevPOST(postString);
}

function handleError(error) {

}

