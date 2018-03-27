/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function checkLogin() {
    if(localStorage['username'] === null || localStorage['username'] === "" 
            || localStorage['username'] === "null" || localStorage['username'] === undefined) {
        displayLogin();
    } else {
        getStatus();
    }
    
}

function displayLogin() {
    console.log("switching");
    window.location.href = "login.html";
}

function getStatus() {
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getPersonalStatus.php";
    var post = "username=" + localStorage['username'];
    console.log(post);
    var responseFunction = function (data, status) {
        localStorage['sickRequest'] = data;
        console.log(data + "response");
        updateButtonUI();
    };
    $.post(URL, post, responseFunction);
    
}
    


