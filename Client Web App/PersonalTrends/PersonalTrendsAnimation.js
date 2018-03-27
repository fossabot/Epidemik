/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var pTrendsAreShown = false;

function properlyShowPTrends() {
    if (pTrendsAreShown) {
        hidePTrends();
    } else {
        showPTrends();
    }
    pTrendsAreShown = !pTrendsAreShown;
}

function showPTrends() {
    width = $(document).width() / 5;
    $("#pTrendsView").animate({
        width: width,
        left: 10
    }, 1000, function () {
        //Completion 
    });
}

function hidePTrends() {
    width = 0;
    $("#pTrendsView").animate({
        width: width,
        left: 0
    }, 1000, function () {
        // Animation complete.
    });
}



