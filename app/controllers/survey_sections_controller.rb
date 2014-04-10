class SurveySectionsController < ApplicationController
  
  def show
    @errors = []
  	@survey = Survey.find(params[:survey_id])
  	@survey_section = @survey.sections.find(params[:index])
  	if @survey.sections.where(index: (params[:index].to_i + 1)).count > 0
  	  session[:next_page] = survey_section_path(@survey, params[:index].to_i + 1)
	  else
	    session[:next_page] = survey_completed_path(@survey)
	  end

  	@questions = @survey_section.questions

  	@user = current_user
  end

  
  def answer
    @errors = []
    @survey = Survey.find(params[:survey_id])
    @survey_section = @survey.sections.find(params[:index])
    @questions = @survey_section.questions
    

    pending_answers = []
    answer_params.each do |ans_params|
      ans = Answer.new(ans_params.merge(user: current_user))
      pending_answers << ans
    

      if !ans.valid?
        @errors << ans.errors
        flash.now[:fail] = "There were errors with your answers: #{ans_params}"
      end
    end

    if @errors.any?
      render 'show'
    else
      pending_answers.each {|ans| ans.save}
    end


    # This line will go to a holding  page for debugging purposes, unless in production mode.
    redirect_to session[:next_page] if Rails.env.production? 
  end

  private

    # This method find the parameters for the answer to a specific question, and returns only the permitted variables
    # Note: since question_option can be a list of answers, this is also permitted
    def answer_params

      all_answers = []

      params[:answers].each do |q, ans|
        if ans[:answer_text].nil?
          ans[:answer_text] = QuestionOption.find(ans[:option_id]).option_choice.choice_name
        end

        ans_params = ActionController::Parameters.new(ans)

        all_answers << ans_params.permit(:answer_text, :option_id)
      end

      return all_answers
    end

end
