$(function() {

	// When tab changes, it updates the hidden value to the relevant survey section
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
	  $('input[name="survey_section').attr("value", e.target.getAttribute("sec")) 
	})

	// Function to change the question type box when value is changed
	$('[id^=question_group_id]').change(function() {
	  var type = $(this).val();
	  var option_types = ["3", "4", "5"];
	  var idx = $(this).attr('id').substr(17)
	  if(option_types.indexOf(type) > -1 ){
	  	$("#question-options" + idx).show();
	  } else {
	  	$("#question-options" + idx).hide();
	  }
	  // $("#option_choice_option_group_id").attr("value", type);
	});
	$("#question-option input").attr("name", "option_choice[0][choice_name]");
	var qc = 1;

	$("[id^=add-question-option]").click(function(e){
		console.log(e)
		var idx = $(this).attr('id').substr(19)
		e.preventDefault();
		var opt = $("#question-option" + idx).clone();
		opt.find("input").attr("name",  "option_choice[" + qc + "][choice_name]");
		opt.find("input").val("");
		$("#add-question-option" + idx).before(opt)
		qc++;
	});
});