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
        window.location.href = "sickness.html"
    }
    updateButtonUI();
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
    console.log(isSick);
    if (isSick) { //Handle Becoming Healthy
        document.getElementById("sickOrHealthy").style.backgroundColor = "#4CAF50";
        document.getElementById("sickOrHealthy").getElementsByTagName("span")[0].innerHTML = "Healthy";
    } else { //Handle Becoming Sick
        localStorage['sickRequest'] = null;
        document.getElementById("sickOrHealthy").style.backgroundColor = "rgb(83, 28, 69)";
        document.getElementById("sickOrHealthy").getElementsByTagName("span")[0].innerHTML = "Sick";
    }
}

