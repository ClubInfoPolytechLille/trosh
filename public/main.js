$.fn.extend({
    animateCss: function (animationName) {
        var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
        $(this).addClass('animated ' + animationName).one(animationEnd, function() {
            $(this).removeClass('animated ' + animationName);
        });
    }
});

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

    var oldScore = 0;
    var shakeStart = 0;
    var SHAKE_DURATION = 10
    var SHAKE_MAX_THRESOLD = 100

    function redrawScores() {
        var sortable = [];
        scores.sort(function(b, a) {return a.score - b.score})
        var list = $('#scores ol');
        list.empty();
        for (i in scores) {
            if (i < 8) {
                var obj = scores[i];
                list.append($('<li>').text(obj.score + ' - ' + obj.name));
            }
        }
        if (scores[0]) {
            $('#bestBlock').css('display', 'block');
            $('#bestBlock .score').text(scores[0].score);
            $('#bestBlock .name').text(scores[0].name);
            if (scores[0].score > oldScore) {
                $('#bestBlock').animateCss('rotateIn');
                oldScore = scores[0].score;
                shakeStart = Date.now()/1000;
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

    function shake(thresold) {
        var x = Math.round((2*Math.random()-1)*thresold);
        var y = Math.round((2*Math.random()-1)*thresold);
        $('body').css('transform', 'translate('+x+'px, '+y+'px)');
    }

    var h = $('#stars').height();
    var w = $('#stars').width();

    for (var i = 0; i < 10; i++) {
        $('#stars').append($('<img>').attr('src', 'graphics/star.png').css('top', (Math.random() * h) + 'px'))
    }

    (function anim() {
        var now = Date.now()/1000;

        // Logo
        var scale = (Math.sin(now*5) + 1)/5 + 0.7;
        var rot = Math.sin(now*10)/10;
        logo.css('transform', 'rotate(' + rot + 'rad) scale(' + scale + ')');
        rainbowColor($('#bestBlock .score'));

        // Shake
        if (now - shakeStart < SHAKE_DURATION) {
            shake(Math.exp(10 * (shakeStart - now) / SHAKE_DURATION) * SHAKE_MAX_THRESOLD)
        }

        // Stars
        $('#stars img').each(function(i, el) {
            var e = $(el);
            var pos = e.position()
            if (pos.top < 0) {
                e.css('top', h + 'px');
                e.css('left', Math.floor(Math.random() * w) + 'px');
            } else {
                e.css('top', (pos.top - 100) + 'px');
            }
        });

        requestAnimationFrame(anim);

    })();


});
