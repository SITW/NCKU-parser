var fs = require('fs');

var pyear = process.argv[2];
var process_count = 0;
var m = [];
for (var i = 12; i >= 1; i--) {
	m[i] = [];
}


var readYearData = fs.readFile('../club-event-fragment/' + pyear + '/' + pyear + '.json', function(err, data) {
	if (err) {
		console.log(err);
	}else {
		var data_json = JSON.parse(data);
		var data_length = data_json.length;

		for(var j = data_length - 1; j >=0; j--) {
			_loopAct(data_json[j])
		}
		

		for (var i = 12; i >= 1; i--) {
			_insert_arr(m[i], pyear, i)
		}
		
		function _loopAct (data) {
			var club_act = data["活動時間"];
			var act_month = club_act.substr(4, 2);
			m[parseInt(act_month, 10)].push(data);
			process_count++;
		}

		function _insert_arr (arr, year, month) {
			console.log(process_count);
			var act_str = JSON.stringify(arr);
			fs.writeFile('../club-event-fragment/' + year + '/' + year + '-' + month + '.json', act_str)
		}
	}
})