var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http)

var cfg = require('./cfg.js')
var tw = require('node-tweet-stream')(cfg)
var tp = require('twitter')(cfg)

var tweets = [];
var tag = '#LeClubInfoCestCool';

io.on('connection', function(socket) {
	socket.on('track', function(tag) {
		tw.track(tag);
	});
	socket.on('untrack', function(tag) {
		tw.untrack(tag);
	});
	console.log('Someone connected');
	socket.emit('tag', tag);
	for (tweet in tweets) {
		socket.emit('tweet', tweets[tweet]);
	}
});

function twe(tweet) {
	console.log('Tweet', tweet.text)
	tweets.push(tweet)
	io.emit('tweet', tweet)
}

tp.get('search/tweets', {q: tag, count: 10}, function(err, tweets, rep) {
	if (err) {
		console.log(err);
	} else {
		for (tweet in tweets.statuses) {
			twe(tweets.statuses[tweet])
		}
	}
});

tw.track(tag);
tw.on('tweet', twe)

setInterval(function msg() {
	var whole = require('fs').readFileSync('sub.txt', 'utf8');
	console.log(whole)
	ex = whole.split('\n');
	id =  Math.floor((Math.random() * (ex.length - 1))); 
	io.emit('msg', ex[id])
	console.log('MSG', id, ex[id]);
}, 30000);

app.use(express.static(__dirname))

http.listen(3000, function(){
  console.log('listening on *:3000');
});
