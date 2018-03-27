/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global google */

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
        if(data === "1") { //Login Sucessful
            localStorage['username'] = username.value;
            window.location.href = localStorage['prevPath'];
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
    var geocoder = new google.maps.Geocoder();
    var address = address.value;

    //Function to covert address to Latitude and Longitude
    var getLocation =  function(address) {
      var geocoder = new google.maps.Geocoder();
      geocoder.geocode( { 'address': address}, function(results, status) {
        if (status === google.maps.GeocoderStatus.OK) {
            var latitude = results[0].geometry.location.lat();
            var longitude = results[0].geometry.location.lng();
            recieveLocation(latitude, longitude);
        } 
      }); 
    };

    //Call the function with address as parameter
    getLocation(address);

}

function recieveLocation(lat, long) {
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Notifications/recieveDeviceID.php";
    var post = "deviceID=&username=" + username + "&password=" + password 
            + "&latitude=" + lat + "&longitude=" + long + "&create=true";
    var responseFunction = function (data, status) {
        if(data === "1") { //Login Sucessful
            localStorage['username'] = username;
            window.location.href = localStorage['prevPath'];
        } else {
            document.getElementById("usernameText").value = "This account already exists";
        }
    };
    $.post(URL, post, responseFunction);
}

