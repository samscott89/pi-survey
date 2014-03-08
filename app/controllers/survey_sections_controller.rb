class SurveySectionsController < ApplicationController
  def show
  	@survey = Survey.find(params[:survey_id])
  	@survey_section = @survey.sections.find(params[:index])
  	if @survey.sections.where(index: (params[:index].to_i + 1)).count > 0
	  session[:next_page] = survey_section_path(@survey, params[:index].to_i + 1)
	else
	  session[:next_page] = survey_completed_path(@survey)
	end

  	@questions = @survey_section.questions

  	@answers = {}
	@questions.each do |q|
		@answers[q] = Answer.new(user: current_user)
	end  	

  	@user = current_user
  end

  
  def answer
    # This is where I need to handle submitted answers!

    # redirect_to session[:next_page]
  end
  

end
