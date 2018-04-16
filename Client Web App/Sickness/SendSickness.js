/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function go_back() {
    window.location.href = "index.html";
}

function send_sickness() {
    var element = document.getElementById("disease_selector");
    getInfection(element.value);
    isSick = true;
    window.location.href = "index.html";
}


function getInfection(disease_name) {
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
    var username = localStorage['username'];
    var today = yyyy + '-' + mm + '-' + dd;
    var postString = "date=" + today +
            "&username=" + username +
            "&disease_name=" + disease_name;
    localStorage['sickRequest'] = postString;
    sendPOST(postString);
}

function sendPOST(toSend) {
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/recieveDisease.php";
    var responseFunction = function (data, status) {
    };
    $.post(URL, toSend, responseFunction);
}