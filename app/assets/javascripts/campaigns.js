$(function() {

	var sc = 1

	$("#add-campaign-survey").click(function(e){
		console.log(e)
		e.preventDefault();
		var opt = $("#campaign-surveys").clone();
		opt.find("input,select").prop("name", function() { return $(this).prop('name').replace('[0]', "[" + sc + "]")});
		opt.find('select').val(0);
		$("#add-campaign-survey").before(opt)
		sc++;
	});

});
