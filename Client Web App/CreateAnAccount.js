/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var username;
var password;

function addAddress() {

    var toInsert = "<label><b>Address</b></label><input type=\"text\" id=\"addressText\" placeholder=\"Enter Address\" name=\"add\" required>";
    document.getElementById("loginTexts").innerHTML += toInsert;    // Get the <ul> element to insert a new node

    var parent = document.getElementById("buttons");
    var child = document.getElementById("createAcc");
    parent.removeChild(child);


}

function loginReact() {

    var username = document.getElementById("usernameText");
    var password = document.getElementById("passwordText");
    var address = document.getElementById("addressText");

    if (address !== null) {
        createAccount(username, password, address);
    } else {
        login(username, password);
    }
}

// HTML Element, HTML Element -> Void
function login(username, password) {
    // Sending and receiving data in JSON format using POST method
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Notifications/recieveDeviceID.php";
    var post = "deviceID=&username=" + username.value + "&password=" + password.value + "&login=true";
    var responseFunction = function (data, status) {
        console.log(data);
        if(data === "1") { //Login Sucessful
            localStorage['username'] = username.value;
            window.location.href = "index.html";
        } else {
            username.value = "Please Enter A Valid Login";
        }
    };
    $.post(URL, post, responseFunction);
}

// HTML Element, HTML Element, HTML Element -> Void
function createAccount(username, password, address) {
    // Sending and receiving data in JSON format using POST method
    this.username = username.value;
    this.password = password.value;
    getLocation(recieveLocation);
}

function recieveLocation(lat, long) {
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Notifications/recieveDeviceID.php";
    var post = "deviceID=&username=" + username + "&password=" + password 
            + "&latitude=" + lat + "&longitude=" + long + "&create=true";
    var responseFunction = function (data, status) {
        if(data === "1") { //Login Sucessful
            localStorage['username'] = username.value;
            window.location.href = "index.html";
        } else {
            document.getElementById("usernameText").value = "This account already exists";
        }
    };
    $.post(URL, post, responseFunction);
}

