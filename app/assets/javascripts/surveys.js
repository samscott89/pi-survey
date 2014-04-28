$(function() {

	// When tab changes, it updates the hidden value to the relevant survey section
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
	  $('input[name="survey_section').attr("value", e.target.getAttribute("sec")) 
	})

	// Function to change the question type box when value is changed
	$("#question_group_id").change(function() {
	  var type = $(this).val();
	  var option_types = ["3", "4", "5"];
	  if(option_types.indexOf(type) > -1 ){
	  	$("#question-options").show();
	  } else {
	  	$("#question-options").hide();
	  }
	  // $("#option_choice_option_group_id").attr("value", type);
	});
	$("#question-option input").attr("name", "option_choice[0][choice_name]");
	var qc = 1;

	$("#add-question-option").click(function(e){
		console.log(e)
		e.preventDefault();
		var opt = $("#question-option").clone();
		opt.find("input").attr("name",  "option_choice[" + qc + "][choice_name]");
		opt.find("input").val("");
		$("#add-question-option").before(opt)
		qc++;
	});
});