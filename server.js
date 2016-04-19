#!/usr/bin/env node
var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);
var port = process.env.PORT || 3000;
var url = require('url');
var fs = require('fs');

var scores = [];
loadScores();

server.listen(port, function() {
    console.log('Server listening at port %d', port);
});

app.use(express.static(__dirname + '/public'));

app.get('/', function(req, res) {
    res.sendStatus(200);
});

app.get('/addScore', function(req, res) {
    var query = url.parse(req.url, true).query;
    addScore(parseInt(query.score), query.name);
    res.sendStatus(200);
});

io.on('connection', function(socket) {
    socket.on('getScores', function() {
        socket.emit('scores', scores);
    });

});

function loadScores() {
    scores = JSON.parse(fs.readFileSync('scores.json', 'utf8'));
}

function saveScores() {
    fs.writeFileSync('scores.json', JSON.stringify(scores), 'utf8');
}

function addScore(score, name) {
    console.log("SCORE %d by %s", score, name);
    var obj = {score: score, name: name};
    scores.push(obj);
    io.emit('newScore', obj);
    saveScores();
}

setInterval(function msg() {
    var whole = require('fs').readFileSync('sub.txt', 'utf8');
    ex = whole.split('\n');
    id =  Math.floor((Math.random() * (ex.length - 1))); 
    io.emit('msg', ex[id])
    console.log('MSG', id, ex[id]);
}, 30000);

