
$(function() {

	// When tab changes, it updates the hidden value to the relevant survey section
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
	  $('input[name="survey_section').attr("value", e.target.getAttribute("sec")) 
	})

	// Initialises the question type code
	  $("#question-options").html("The selected question type is: " + $("#question_group_id").val());

	// Function to change the question type box when value is changed
	$("#question_group_id").change(function() {
	  var type = $(this).val();
	  $("#question-options").html("The selected question type is: " + type);
	})
});