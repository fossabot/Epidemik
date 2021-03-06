/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

getTrends(localStorage['username']);

function getPTrends(username) {
    var postString = 
            "get=true&username=" + username;
    var URL = "https://rbradford.thaumavor.io/iOS_Programs/Epidemik/getTrends.php";
    var responseFunction = function (data, status) {
        addPTrends(data);
    };
    $.post(URL, postString, responseFunction);
}

function addPTrends(trends) {
    this.splits = trends.split("\n");
    for (const i in splits) {
        var parts = splits[i].split(",");
        if (parts.length < 2) {
            continue;
        }
        addTrend(parts[0], parts[1]);
    }
}

function addPTrend(name, weight) {
    weight = Math.floor(weight*10)/10;
    var trendsView = document.getElementById("trendsView");
    var newdiv = document.createElement('div');   //create a div
    newdiv.id = 'trend';                      //add an id
    newdiv.textContent = name + ": " + weight + "% Infection Chance";

    trendsView.appendChild(newdiv);                 //append to the doc.body

    console.log(trendsView);
}


