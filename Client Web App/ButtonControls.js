/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var isSick = (localStorage.getItem("sickRequest") !== null)
&& (localStorage.getItem("sickRequest") !== "null") && (localStorage.getItem("sickRequest") !== undefined);

function handleClick() {
    if (isSick) { //Handle Becoming Healthy
        var toSend = localStorage['sickRequest'] || "";
        toSend += "&delete=true";
        sendPOST(toSend);
        isSick = false;
        localStorage['sickRequest'] = null;
    } else { //Handle Becoming Sick
        getLocation(getInfection);
        isSick = true;
    }
    updateButtonUI();
}

function getInfection(lat, long) {
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
    localStorage['lat'] = lat;
    localStorage['long'] = long;
    var today = yyyy + '-' + mm + '-' + dd;
    var postString = "date=" + today +
            "&latitude=" + lat +
            "&longitude=" + long +
            "&disease_name=" + "General Sickness" +
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
    isSick = (localStorage['sickRequest'] !== null)
        && (localStorage['sickRequest'] !== "null") && localStorage['sickRequest'] !== undefined && localStorage['sickRequest'] !== "";
    if (isSick) { //Handle Becoming Healthy
        document.getElementById("sickOrHealthy").style.backgroundColor = "#4CAF50";
        document.getElementById("sickOrHealthy").getElementsByTagName("span")[0].innerHTML = "Healthy";
    } else { //Handle Becoming Sick
        localStorage['sickRequest'] = null;
        document.getElementById("sickOrHealthy").style.backgroundColor = "rgb(83, 28, 69)";
        document.getElementById("sickOrHealthy").getElementsByTagName("span")[0].innerHTML = "Sick";
    }
}

