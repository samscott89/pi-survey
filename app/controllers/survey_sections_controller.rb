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

  	@user = current_user
  end

  
  def answer
    @errors = []
    @survey = Survey.find(params[:survey_id])
    @survey_section = @survey.sections.find(params[:index])
    @questions = @survey_section.questions
    

    pending_answers = []
    answer_params.each do |ans_params|
      ans = Answer.new(user: current_user)
      pending_answers << ans
    
      ans.assign_attributes(ans_params)

      if !ans.valid?
        @errors << ans.errors
        flash.now[:fail] = "There were errors with your answers: #{ans_params}"
      end
    end

    if @errors.nil?
      pending_answers.each {|ans| ans.save}
    else
      render 'show'
    end


    # This line will go to a holding  page for debugging purposes, unless in production mode.
    redirect_to session[:next_page] if Rails.env.production? 
  end

  private

    # This method find the parameters for the answer to a specific question, and returns only the permitted variables
    # Note: since question_option can be a list of answers, this is also permitted
    def answer_params
      
      all_answers = []
    
      @questions.each do |q|
        if params[:answers]["q#{q.id}"].nil?
          all_answers << {}
        else
          params.require(:answers).require("q#{q.id}").each do |ans|

            # IF the question option is not selected (i.e. there was only one choice)
            if ans[:option_id].nil?
              #TODO: This should return an error if there is more than one option
              ans[:option_id] = QuestionOption.where(question: q).first.id
            else
              # Replace the option_choice with the actual question_option
              if ans[:answer_text].nil?
                ans[:answer_text] = OptionChoice.find(ans[:option_id]).choice_name
              end
              ans[:option_id] = QuestionOption.where(question: q, option_choice_id: ans[:option_id]).first.id
            end

            ans_params = ActionController::Parameters.new(ans)

            # Remove all other parameters passed.
            all_answers << ans_params.permit(:answer_text, :option_id)
          end
        end
      end

      return all_answers
    end

end
