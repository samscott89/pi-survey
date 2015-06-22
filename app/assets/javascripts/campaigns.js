$(function() {
	sname  = $("#campaign-survey").find("input,select").prop('name');
	var idx = parseInt(sname.substr(sname.indexOf('attributes][') + 12, sname.length - 50));
	var sc = idx + 1;

	$("#add-campaign-survey").click(function(e){
		console.log(e)
		e.preventDefault();
		var opt = $("#campaign-survey").clone();

		opt.find("input,select").prop("name", function() { 
			return $(this).prop('name').replace('[' + idx + ']', "[" + sc + "]")
		});
		opt.find('select').val(0);
		$("#add-campaign-survey").before(opt)
		sc++;
	});

});
