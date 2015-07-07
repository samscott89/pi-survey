$(function() {

	// When tab changes, it updates the hidden value to the relevant survey section
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
	  $('input[name="survey_section').attr("value", e.target.getAttribute("sec")) 
	});

	$("#add-section-tab").click(function(e){
		console.log("Add section - Click!");
	});

	// Function to change the question type box when value is changed
	$('[id^=question_group_id]').change(function() {
	  var type = $(this).val();
	  var option_types = ["3", "4", "5", "7"];
	  var idx = $(this).attr('id').substr(17)
	  console.log(idx);
	  console.log(option_types);
	  console.log(type);
	  if(option_types.indexOf(type) > -1 ){
	  	$("#question-options" + idx).show();
	  } else {
	  	$("#question-options" + idx).hide();
	  }
	  // $("#option_choice_option_group_id").attr("value", type);
	});
	// $("[id^=question-option] input").attr("name", "option_choice[0][choice_name]");
	var qc = []
	$("[id^=question-option]").each(function(e){
		var idx = $(this).attr('id').substr(19)
		qc[idx] = 1;
	})
	

	$("[id^=add-question-option]").click(function(e){
		console.log(e)
		e.preventDefault();
		var idx = $(this).attr('id').substr(19)
		var opt = $("#question-option" + idx).clone();
		opt.find("input").attr("name",  "option_choice[" + qc[idx] + "][choice_name]");
		opt.find("input").val("");
		$("#add-question-option" + idx).before(opt)
		qc[idx]++;
		console.log("idx: " + idx)
		console.log(opt.find("input"))
	});


	// This code here handles setting has_other=1 when a radio button is set to "other"
	$('[id$=option_id_0]:radio').each(function(){
		this_id = $(this).prop('id');
		var ans_id = this_id.substr(0,this_id.indexOf('answer_options_attributes'));
		if($('#' + ans_id + 'has_other').val() == 't') {
			$(this).prop('checked', true)
		}
		$("input[id^=" + ans_id + "]:radio").change(function(){
			if($(this).prop('id').indexOf('option_id_0') > 0){
				$('#' + ans_id + 'has_other').val('t');
			} else{
				$('#' + ans_id + 'has_other').val('f');
			}
		});

	})
});