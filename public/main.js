$(function() {
    var socket = io();
    var scores = [];
    var list = $('#scores ol');

    socket.emit('getScores');

    socket.on('scores', function(newScores) {
        scores = newScores;
        redrawScores();
    });

    socket.on('newScore', function addScore(obj) {
        scores.push(obj);
        redrawScores();
    });

    socket.on('msg', function(msg) {
        $('#sub').text(msg);
    });

    function redrawScores() {
        var sortable = [];
        scores.sort(function(b, a) {return a.score - b.score})
        var list = $('#scores ol');
        list.empty();
        for (i in scores) {
            if (i < 15) {
                var obj = scores[i];
                list.append($('<li>').text(obj.score + ' - ' + obj.name));
            }
        }
    }

    function rainbowColor(el) {
        var hue = Math.floor(Math.random()*360);
        el.css('filter', 'hue-rotate('+hue+'deg)');
    }

    var logo = $('#logo');

    setInterval(function rainbowLogo() {
        rainbowColor(logo);
    }, 500);

    (function anim() {
        var now = Date.now()/1000;

        // Logo
        var scale = (Math.sin(now*5) + 1)/5 + 0.7;
        var rot = Math.sin(now*10)/10;
        logo.css('transform', 'rotate(' + rot + 'rad) scale(' + scale + ')');
        requestAnimationFrame(anim);

    })();


});
