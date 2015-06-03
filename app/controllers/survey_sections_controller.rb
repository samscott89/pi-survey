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
    @user = current_user
    @survey = Survey.find(params[:survey_id])
    @survey_section = @survey.sections.where(index: params[:index]).first
    @questions = @survey_section.questions

    if @user.nil?
      @user = User.create(temporary: true)
      @user.save!(validate: false)
      session[:guest_user_id] = @user.id
      flash[:info] = "You are not logged in. Answers will be stored temporarily until you log in."
    end

    pending_answers = []
    answer_params.each do |ans_params|
      ans = Answer.new(ans_params.merge(user: @user))
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

      #For each answer, if there is no answer text (missing as opposed to blank), then try and find
      # a matching multiple choice answer.
      # If this is also missing, try to submit a nil value for this question. 

      #The different cases:
      # 1. The simplest: we have an option_id and a answer_text.
      # 2. Nothing chosen: we have a missing answer_text (i.e. nil) and option_ids are empty.
      # 3. Single option: we have an option_id and no answer_text
      # 4. Multiple options: we have multiple option_ids and no answer text.

      params[:answers].each do |q, ans|
        if ans[:answer_text].nil? #Multiple choice element (2,3,4)
          if ans[:option_id].kind_of? Array
            ans[:option_id] = ans[:option_id].reject {|opt| opt.empty?} 
            if ans[:option_id].empty? # No answer given (2)
              ans[:option_id] = QuestionOption.where(option_choice_id: 54, question_id: q).first.id
              ans[:answer_text] = ""
              all_answers << {answer_text: ans[:answer_text],option_id: ans[:option_id] }
            else # Multiple answers (4)
              all_answers.concat ans[:option_id].map {|x| {option_id: x, answer_text:QuestionOption.find(x).option_choice.choice_name }}
            end
          end
          else # Single option chosen in multiple choice element (3)
            all_answers << {answer_text: ans[:answer_text],option_id: ans[:option_id] }
          end
        else # Simple response (1)
          all_answers << {answer_text: ans[:answer_text],option_id: ans[:option_id] }
      end

      return all_answers
    end

    def survey_section_params
      params.require(:survey_section).permit(:name, :title, :required, :index)
    end
end
