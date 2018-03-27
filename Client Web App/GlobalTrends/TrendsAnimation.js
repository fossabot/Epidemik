/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var trendsAreShown = false;

function properlyShowTrends() {
    if (trendsAreShown) {
        hideTrends();
    } else {
        showTrends();
    }
    trendsAreShown = !trendsAreShown;
}

function showTrends() {
    width = $(document).width() / 5;
    $("#trendsView").animate({
        width: width,
        left: 10
    }, 1000, function () {
        //Completion 
    });
}

function hideTrends() {
    width = 0;
    $("#trendsView").animate({
        width: width,
        left: 0
    }, 1000, function () {
        // Animation complete.
    });
}



