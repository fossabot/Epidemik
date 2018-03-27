/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function getEmpData() {
    
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Management/getEmployeeStatus.php";
    var post = "email=" + localStorage['bEmail'];
    var responseFunction = function (data, status) {
        processText(data);
    };
    $.post(URL, post, responseFunction);
    
}

function processText(text) {
    var statusDisplay = document.getElementById("employees");
    while (statusDisplay.firstChild) {
        statusDisplay.removeChild(statusDisplay.firstChild);
    }
    this.splits = text.split("\n");
    for (const i in splits) {
        var parts = splits[i].split(",");
        if (parts.length < 2) {
            continue;
        }
        var username = parts[0];
        var isHealthy = parts[1] === "";
        
        var newdiv = document.createElement('p');   //create a p
        newdiv.id = 'sickness';                      //add an id
        console.log(parts[1]);
        if(isHealthy) {
            newdiv.textContent = username + " is not sick today";
        } else {
            newdiv.textContent = username + " is sick today";
        }
        statusDisplay.appendChild(newdiv);
    }
}

