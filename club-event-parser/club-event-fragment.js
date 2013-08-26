var fs = require('fs');
var buffer = require('buffer');
var segment_file = '../club-event-fragment';

var event_obj = fs.readFile('../club-event-result/club_event_result.json',function(err, data) {
	if (err) {
		console.log(err);
	}else {
		var data_json = JSON.parse(data);
		var data_length = data_json.length - 1;
		var j = 0;
		var process = 0;
		var c2011_act = [];
		var c2012_act = [];
		var c2013_act = [];
		var c2014_act = [];

		_loopAct(data_json[j])

		function _loopAct (data) {
			var club_act = data["活動時間"];
			var act_year = club_act.substr(0, 4);
			_mkFolder(act_year, data)
		}

		function _mkFolder (act_year, data) {
			fs.exists(segment_file + '/' + act_year, function(exist) {
				if(exist) {

					console.log('append ' + process + ' into files');
					_insertYearData(act_year, data)
					
				}else {

					fs.mkdir(segment_file + '/' + act_year, function() {
						console.log(act_year + ' folder is not exist, going to make one.');
						console.log('create a new folder!');
						_insertYearData(act_year, data)
					})

				}
			})
		}

		function _insertYearData (act_year, data) {
			process++;
			if(act_year == 2011) {
				c2011_act.push(data);
			} else if(act_year == 2012) {
				c2012_act.push(data);
			} else if(act_year == 2013) {
				c2013_act.push(data);
			} else if(act_year == 2014) {
				c2014_act.push(data);
			}

			if(++j <= data_length) {
				_loopAct(data_json[j])
			}else {

				_insertJSON(c2011_act, 2011);
				_insertJSON(c2012_act, 2012);
				_insertJSON(c2013_act, 2013);
				_insertJSON(c2014_act, 2014);

			}

			function _insertJSON (arr, year) {
				var c_str = JSON.stringify(arr)

				fs.writeFile('../club-event-fragment/' + year + '/' + year + '.json', c_str)
			}

		}
	}
})

