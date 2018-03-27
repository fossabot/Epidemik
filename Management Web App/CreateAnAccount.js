/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var email;
var password;
var shouldCreate = false;

function turnToCreate() {

    var parent = document.getElementById("buttons");
    var child = document.getElementById("createAcc");
    parent.removeChild(child);
    shouldCreate = true;

}

function loginReact() {

    var email = document.getElementById("emailText");
    var password = document.getElementById("passwordText");
    
    if (shouldCreate) {
        createAccount(email, password);
    } else {
        login(email, password);
    }
}

// HTML Element, HTML Element -> Void
function login(email, password) {
    // Sending and receiving data in JSON format using POST method
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Management/login.php";
    var post = "email=" + email.value + "&password=" + password.value;
    var responseFunction = function (data, status) {
        if(data === "1") { //Login Sucessful
            localStorage['bEmail'] = email.value;
            window.location.href = "index.html";
        } else {
            email.value = "Please Enter A Valid Login";
        }
    };
    $.post(URL, post, responseFunction);
}

// HTML Element, HTML Element, HTML Element -> Void
function createAccount(email, password, address) {
    // Sending and receiving data in JSON format using POST method
    this.email = email.value;
    this.password = password.value;
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Management/createAcc.php";
    var post = "email=" + this.email + "&password=" + this.password;
    var responseFunction = function (data, status) {
        console.log(data);
        if(data === "1") { //Login Sucessful
            localStorage['bEmail'] = email.value;
            window.location.href = "index.html";
        } else {
            document.getElementById("emailText").value = "This account already exists";
        }
    };
    $.post(URL, post, responseFunction);
}

