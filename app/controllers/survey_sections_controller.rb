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
      puts ans
      puts a.to_json
      puts a.answer_options.to_json
      if !a.valid?
        @errors << a.errors
      end
      pending_answers << a
    end
    
    if @errors.any?
      flash.now[:alert] = "There were errors with your answers: #{pending_answers}"
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
        if ans.nil? # Nothing was answered for this question
          if q.required?
            err = ActiveModel::Errors(self)
            err.add(:question, "is required")
            @errors << err
            next
          else # Question not required => set to default blank value.
            ans = Answer.new(question_id: q.id, answer_text: q.blank.value)
            ans.answer_options.build(option_id: q.blank.id)
          end
        end
      end

      answer_params = []
      params.require(:answers).each do |qid, pa|
        answer_params << pa.permit(:answer_text, answer_options_attributes: [:option_id]).merge(question_id: qid, user_id: user.id)
        puts pa
      end

      answer_params
    end


    def survey_section_params
      params.require(:survey_section).permit(:name, :title, :required, :index)
    end
end
