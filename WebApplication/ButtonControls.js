/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var isSick = (localStorage.getItem("sickRequest") !== "null");

function handleClick() {
    if (isSick) { //Handle Becoming Healthy
        var toSend = localStorage['sickRequest'] || "";
        toSend += "&delete=true";
        sendPOST(toSend);
        document.getElementById("sickOrHealthy").style.backgroundColor = "rgb(83, 28, 69)";
        document.getElementById("sickOrHealthy").setAttribute("value", "Sick");
        isSick = false;
        localStorage['sickRequest'] = null;
    } else { //Handle Becoming Sick
        if ("geolocation" in navigator) {
            navigator.geolocation.getCurrentPosition(getInfection, handleError);
        }
        document.getElementById("sickOrHealthy").style.backgroundColor = "#4CAF50";
        document.getElementById("sickOrHealthy").setAttribute("value", "Healthy");
        isSick = true;
    }
}

function getInfection(location) {
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!

    var yyyy = today.getFullYear();
    if (dd < 10) {
        dd = '0' + dd;
    }
    if (mm < 10) {
        mm = '0' + mm;
    }
    var today = yyyy + '-' + mm + '-' + dd;
    var postString = "date=" + today +
            "&latitude=" + location.coords.latitude +
            "&longitude=" + location.coords.longitude +
            "&disease_name=" + "Common Cold" +
            "&deviceID=" + getDeviceID();
    localStorage['sickRequest'] = postString;
    sendPOST(postString);
}

function sendPOST(toSend) {
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/recieveDisease.php";
    var responseFunction = function (data, status) {
    };
    $.post(URL, toSend, responseFunction);
}

function handleError(error) {

}

function updateButtonUI() {
    if (isSick) { //Handle Becoming Healthy
        document.getElementById("sickOrHealthy").style.backgroundColor = "#4CAF50";
        document.getElementById("sickOrHealthy").setAttribute("value", "Healthy");
    } else { //Handle Becoming Sick
        localStorage['sickRequest'] = null;
        document.getElementById("sickOrHealthy").style.backgroundColor = "rgb(83, 28, 69)";
        document.getElementById("sickOrHealthy").setAttribute("value", "Sick");
    }
}

