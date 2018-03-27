/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function addEmp($username) {
    
    
}

function callAddEmp() {
    var toAdd = window.prompt("Enter the Employee Username","username");
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/Management/addEmployee.php";
    var post = "email=" + localStorage['username'] + "&employee=" + toAdd;
    var responseFunction = function (data, status) {
        getEmpData();
    };
    $.post(URL, post, responseFunction);
    
}


