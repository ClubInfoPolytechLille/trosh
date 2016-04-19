moment.locale('fr', {
    months : "janvier_février_mars_avril_mai_juin_juillet_août_septembre_octobre_novembre_décembre".split("_"),
    monthsShort : "janv._févr._mars_avr._mai_juin_juil._août_sept._oct._nov._déc.".split("_"),
    weekdays : "dimanche_lundi_mardi_mercredi_jeudi_vendredi_samedi".split("_"),
    weekdaysShort : "dim._lun._mar._mer._jeu._ven._sam.".split("_"),
    weekdaysMin : "Di_Lu_Ma_Me_Je_Ve_Sa".split("_"),
    longDateFormat : {
        LT : "HH:mm",
        LTS : "HH:mm:ss",
        L : "DD/MM/YYYY",
        LL : "D MMMM YYYY",
        LLL : "D MMMM YYYY LT",
        LLLL : "dddd D MMMM YYYY LT"
    },
    calendar : {
        sameDay: "[Aujourd'hui à] LT",
        nextDay: '[Demain à] LT',
        nextWeek: 'dddd [à] LT',
        lastDay: '[Hier à] LT',
        lastWeek: 'dddd [dernier à] LT',
        sameElse: 'L'
    },
    relativeTime : {
        future : "dans %s",
        past : "il y a %s",
        s : "quelques secondes",
        m : "une minute",
        mm : "%d minutes",
        h : "une heure",
        hh : "%d heures",
        d : "un jour",
        dd : "%d jours",
        M : "un mois",
        MM : "%d mois",
        y : "une année",
        yy : "%d années"
    },
    ordinalParse : /\d{1,2}(er|ème)/,
    ordinal : function (number) {
        return number + (number === 1 ? 'er' : 'ème');
    },
    meridiemParse: /PD|MD/,
    isPM: function (input) {
        return input.charAt(0) === 'M';
    },
    // in case the meridiem units are not separated around 12, then implement
    // this function (look at locale/id.js for an example)
    // meridiemHour : function (hour, meridiem) {
    //     return /* 0-23 hour, given meridiem token and hour 1-12 */
    // },
    meridiem : function (hours, minutes, isLower) {
        return hours < 12 ? 'PD' : 'MD';
    },
    week : {
        dow : 1, // Monday is the first day of the week.
        doy : 4  // The week that contains Jan 4th is the first week of the year.
    }
});

var startTime = moment().hour(18).minute(30);
var endTime = moment().hour(19).minute(45);
var tag = '#leclubinfocestcool'

var s = null;

var scores = {};

function updateLeaderBoard() {
	var sortable = [];
	for (var name in scores)
	      sortable.push([name, scores[name]])
	sortable.sort(function(b, a) {return a[1] - b[1]})
	var list = $('#lead ol');
	list.empty();
	for (tuple in sortable) {
		list.append($('<li>').text(sortable[tuple][0]));
	}
}

function clearTw() {
	var els = $('#tweets>div');
	for (el in els) {
		if (el > 10) {
			$(els[el]).remove();
		}
	}
}



$(function() {
	twttr.ready(function() {
		console.log('Ready')
		s = io();
		setInterval(function() {
			$('#start').text(startTime.fromNow());
			$('#stop').text(endTime.fromNow());
		}, 1000);
		s.on('tag', function(datag) {
			// tag = datag
		});
		s.on('tweet', function(tweet) {
			var el = $('<div>').hide();
			console.log(tweet)
			var d = new Date(tweet.created_at);
			if (tweet.text.toLowerCase().indexOf(tag) != -1 && startTime.isBefore(d) && endTime.isAfter(d)) { // Si il y a bien le tag
				el.addClass('tag');
				if (scores[tweet.user.name] == undefined) {
					scores[tweet.user.name] = 0;
				}
				scores[tweet.user.name]++;
				updateLeaderBoard();
			}
			$('#tweets').prepend(el);
			twttr.widgets.createTweet(tweet.id_str, el[0], {theme: 'dark', width: 500})
				.then(function(iframe) {
					$(el).show('slow');
					clearTw();
				});
		})
		s.on('msg', function(msg) {
			$('#sub').text(msg);

		});
			
	})
})
