class SurveySectionsController < ApplicationController
  
  def show
    @errors = []
  	@survey = Survey.find(params[:survey_id])
  	@survey_section = @survey.sections.where(index: params[:index]).first
  	if @survey.sections.where(index: (params[:index].to_i + 1)).count > 0
  	  session[:next_page] = survey_section_path(@survey, params[:index].to_i + 1)
	  else
	    session[:next_page] = survey_completed_path(@survey)
	  end

  	@questions = @survey_section.questions

  	@user = current_user

    respond_to do |format|
      format.html {}
      format.json {render json: @survey_section}
    end
  end

  
  def answer
    @errors = []
    @survey = Survey.find(params[:survey_id])
    @survey_section = @survey.sections.where(index: params[:index]).first
    @questions = @survey_section.questions
    

    pending_answers = []
    answer_params.each do |ans_params|
      ans = Answer.new(ans_params.merge(user: current_user))
      pending_answers << ans
    

      if !ans.valid?
        @errors << ans.errors
        flash.now[:danger] = "There were errors with your answers: #{ans_params}"
      end
    end

    if @errors.any?
      render 'show'
    else
      pending_answers.each {|ans| ans.save}
      redirect_to session[:next_page]
    end

  end

  def update
    @survey = Survey.find(params[:survey_id])
    @survey_section = @survey.sections.where(index: params[:index]).first

    @survey_section.assign_attributes(survey_section_params)
    if @survey_section.save
      flash.now[:success] = "Changed"
    else
      flash.now[:danger] = "Could not change"
    end 


    respond_to do |format|
      format.json {render json: @survey_section}
    end
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

    def survey_section_params
      params.require(:survey_section).permit(:name, :title, :required, :index)
    end
end
