/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function getEmpData() {
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Management/getEmployeeStatus.php";
    var post = "email=" + localStorage['username'];
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
        
        var overallDiv = document.createElement('div');   //create a p
        var employeeIDPart = document.createElement('label');
        employeeIDPart.className = "employeeID";
        employeeIDPart.textContent = username;
        var sicknessLabel = document.createElement('label');
        sicknessLabel.className = "sicknessStatus";
        sicknessLabel.id = "sick" + !isHealthy;
        if(isHealthy) {
            sicknessLabel.textContent = "not sick";
        } else {
            sicknessLabel.textContent = "sick";
        }
        var removeButton = document.createElement('button');
        removeButton.className = "removeEmp";
        removeButton.id = username;
        removeButton.onclick = removeEmployee;
        removeButton.textContent = "remove employee";
        
        overallDiv.appendChild(employeeIDPart);
        overallDiv.appendChild(sicknessLabel);
        overallDiv.appendChild(removeButton);
        statusDisplay.appendChild(overallDiv);
    }
    
    //<div id = "employeeID"> </div> <div id = "sicknessStatus"> </div>
}

function removeEmployee() {
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Management/removeEmployee.php";
    var post = "email=" + localStorage['username'] + "&employee=" + this.id;
    var responseFunction = function (data, status) {
        getEmpData();
    };
    $.post(URL, post, responseFunction);
}

