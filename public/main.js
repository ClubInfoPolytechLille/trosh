$(function() {
    var socket = io();
    var scores = [];
    var list = $('#list');

    socket.emit('getScores');
    
    socket.on('scores', function(newScores) {
        scores = newScores;
        redrawScores();
    });

    socket.on('newScore', addScore);

    function redrawScores() {
        list.empty();
        for (s in scores) {
            addScore(scores[s]);
        }
    }

    function addScore(obj) {
        list.append($('<li>').text(obj.score + ' by ' + obj.name));
    }

});
