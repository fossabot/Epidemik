/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function checkLogin() {
    if(localStorage['bEmail'] === null || localStorage['bEmail'] === "" 
            || localStorage['bEmail'] === "null" || localStorage['bEmail'] === undefined) {
        displayLogin();
    } else {
        getEmpData();
    }
    
}

function displayLogin() {
    console.log("switching");
    window.location.href = "login.html";
}
    


