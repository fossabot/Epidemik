/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function checkLogin(prevPath) {
    localStorage['prevPath'] = prevPath;
    if(localStorage['username'] === null || localStorage['username'] === "" 
            || localStorage['username'] === "null" || localStorage['username'] === undefined
            || localStorage['username'] === "undefined") {
        displayLogin();
    } else {
        if(this.prevPath === "index.html") {
            getStatus();
        }
    }
    
}

function displayLogin() {
    window.location.href = "login.html";
}

function getStatus() {
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getPersonalStatus.php";
    var post = "username=" + localStorage['username'];
    var responseFunction = function (data, status) {
        localStorage['sickRequest'] = data;
        updateButtonUI();
    };
    $.post(URL, post, responseFunction);
    
}
    


