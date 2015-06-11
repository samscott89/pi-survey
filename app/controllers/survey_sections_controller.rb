class SurveySectionsController < ApplicationController
  
  def show
    @errors = []
  	@survey = Survey.find(params[:survey_id])
  	@survey_section = @survey.sections.where(idx: params[:index]).first
    if @survey.sections.where(idx: (params[:index].to_i + 1)).count > 0
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
    @answers = []
    if !@active_survey.nil?
      flash[:alert] = "This survey has been submitted and cannot be changed." if @active_survey.completed?
      @answers = Answer.where(question_id: @questions.ids, user_id: @user.id).index_by(&:question_id)
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
    @survey_section = @survey.sections.where(idx: params[:index]).first
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
    @answers = Answer.where(question_id: @questions.ids, user_id: @user.id).index_by(&:question_id)

    pending_answers = []

    answer_params(@questions, @user).each do |ans|
      a = Answer.new(ans)
      if !a.valid?
        @errors << ans_builder.errors
      end
      pending_answers << a
    end
    
=begin
    answer_params.each do |qid, ans_params|
      if @answers[qid.to_i].nil?
        ans = Answer.new(ans_params.merge(user: @user))
      else
        ans = @answers[qid.to_i]
        # This doesn't quite work due to... multiple choice answers as usual :(
        #ans.assign_attributes(answer_text: ans_params[:answer_text], option_id: ans_params[:option_id])
      end
      pending_answers << ans
      if !ans.valid?
        @errors << ans.errors
      end
    end
=end
    

    if @errors.any?
      flash.now[:alert] = "There were errors with your answers: #{ans_params}"
      render 'show'
    else
      pending_answers.each {|a| a.save}
      if @active_survey.nil?
        @user.active_surveys.create(survey: @survey, completed: false)
      else
        @active_survey.touch # this updates the "updated_at" column... pretty cool!
      end
      redirect_to session[:next_page]
    end

  end

  def update
    @survey = Survey.find(params[:survey_id])
    @survey_section = @survey.sections.where(ixd: params[:index]).first

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

  def new
    @survey = Survey.find(params[:survey_id])
    idx = (@survey.sections.pluck(:idx) << 0).max + 1
    @section = @survey.sections.create(name: "Section #{idx}", title: "New Section", idx: idx)
    flash[:success] = "Section added."

    redirect_to edit_survey_path(@survey, index: idx)
  end

  def delete
    @survey = Survey.find(params[:survey_id])
    @survey_section = @survey.sections.where(idx: params[:index]).first


    sections_to_increment = @survey.sections.where("idx > ?", params[:index]).order(idx: :asc)
    @survey_section.destroy
    sections_to_increment.each do |sec|
      sec.update_attributes(idx: sec.idx-1)
    end

    flash[:info] = "Deleted #{@survey_section.name}." #" using params: #{params}."
    
    redirect_to edit_survey_path(@survey, idx: params[:index].to_i-1)
  end

  private

    def answer_params(questions, user)
      params[:answers] ||= {} # Initialise if not set (i.e. no answers given)

      questions.each do |q|
        ans = params[:answers][q.id.to_s]
        if ans.nil?
          if q.required?
            err = ActiveModel::Errors(self)
            err.add(:question, "is required")
            @errors << err
            next
          else
            ans = Answer.new(question_id: q.id, answer_text: q.blank.value)
            ans.answer_options.build(option_id: q.blank.id)
          end
        end
      end

      answer_params = []
      params.require(:answers).each do |qid, pa|
        answer_params << pa.permit(:answer_text, answer_options_attributes: [:option_id]).merge(question_id: qid, user_id: user.id)
      end

      answer_params
    end




=begin
    # This method find the parameters for the answer to a specific question, and returns only the permitted variables
    # Note: since question_option can be a list of answers, this is also permitted
    def answer_params

      # all_answers = []

      params[:answers] ||= {} # No answers at all
      @questions.each do |q|
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
          ans = ans[:option_id].map {|x| {option_id: x, answer_text: QuestionOption.find(x).option_choice.choice_name, question_id: q.id}}
        else # handle single answer
          if ans[:answer_text].nil? #No answer text for radio buttons etc.
            ans = {option_id: ans[:option_id], answer_text: QuestionOption.find(ans[:option_id]).option_choice.choice_name}
          end
          # all_answers << {q.id => {answer_text: ans[:answer_text],option_id: ans[:option_id]} }
        end

      end #questions.each

        return params[:answers]
    end
=end

    def survey_section_params
      params.require(:survey_section).permit(:name, :title, :required, :index)
    end
end
