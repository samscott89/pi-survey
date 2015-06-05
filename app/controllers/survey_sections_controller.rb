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

    if @user.nil? and !session[:guest_user_id].nil?
      @user = User.find(session[:guest_user_id])
      flash[:info] = "You are not logged in. Answers will be stored temporarily until you log in. \n" +
      "You are currently logged in as guest #{@user.id}"
    end

    @active_survey = ActiveSurvey.where(survey_id: @survey, user_id: @user).first

    if !@active_survey.nil? and @active_survey.completed?
      flash[:warning] = "This survey has been submitted and cannot be changed."
    end

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
      if session[:guest_user_id].nil?
        @user = User.create(temporary: true)
        @user.save!(validate: false)
        session[:guest_user_id] = @user.id
      else
        @user = User.find(session[:guest_user_id])
      end
      flash[:info] = "You are not logged in. Answers will be stored temporarily until you log in. \n" +
      "You are currently logged in as guest #{@user.id}"
    end


    @active_survey = ActiveSurvey.where(survey_id: @survey, user_id: @user).first


    pending_answers = []
    answer_params.each do |ans_params|
      ans = Answer.new(ans_params.merge(user: @user))
      pending_answers << ans
      if !ans.valid?
        @errors << ans.errors
      end
    end

    if @errors.any?
      flash.now[:danger] = "There were errors with your answers: #{ans_params}"
      render 'show'
    else
      pending_answers.each {|ans| ans.save}
      if @active_survey.nil?
        @user.active_surveys.create(survey: @survey, completed: false)
      end
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

      @questions.each do |q|
        params[:answers] ||= {} # No answers at all
        ans = params[:answers][q.id.to_s]
        if ans.nil? # handle no answers
          if q.required?
            err = ActiveModel::Errors(@survey_section)
            err.add(:option_id, "Question is required")
            @errors << err
            next
          else
            ans = {answer_text: q.blank.value, option_id: q.blank.id, question_id: q.id}
          end
        end

        if ans[:option_id].kind_of? Array # handle multiple answers
          all_answers.concat ans[:option_id].map {|x| {option_id: x, answer_text: QuestionOption.find(x).option_choice.choice_name, question_id: q.id}}
        else # handle single answer
          if ans[:answer_text].nil? #No answer text for radio buttons etc.
            ans[:answer_text] = QuestionOption.find(ans[:option_id]).option_choice.choice_name
          end
          all_answers << {answer_text: ans[:answer_text],option_id: ans[:option_id], question_id: q.id }
        end

      end #questions.each

        return all_answers
    end

    def survey_section_params
      params.require(:survey_section).permit(:name, :title, :required, :index)
    end
end
