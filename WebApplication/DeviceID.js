/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function getDeviceID() {
    if(localStorage['deviceID'] === "null" || localStorage['deviceID'] === undefined) {
        setDeviceID();
    }
    return localStorage['deviceID'];
}

function setDeviceID() {
    localStorage['deviceID'] = Math.random();
}

