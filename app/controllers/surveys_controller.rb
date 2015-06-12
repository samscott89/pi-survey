class SurveysController < ApplicationController


  def show
  	@survey = Survey.find(params[:id])

    respond_to do |format|
      format.html {}
      format.json {render json: @survey}
    end
  end

  def index
  	@surveys = Survey.page params[:page]
  end

  def finish
    @user = view_context.current_or_guest_user
    if @user.nil?
      flash.now[:alert] = "No user found"
    end
    @active_survey = ActiveSurvey.where(user_id: @user, survey_id: params[:survey_id]).first
    @active_survey.update(completed: true)
  end

  def new
    @survey = Survey.new
  end

  def create
  	@survey = Survey.new(survey_params)
    if @survey.save
      flash[:notice] = "Survey Created"
       @survey.sections.create(name: "Section 1", title: "New Section", idx: 1)
       redirect_to edit_survey_path @survey
    else
      flash.now[:fail] = "Error creating survey"
      render 'new'
    end
  end

  def edit
    id = params[:survey_id]
    id ||= params[:id]
  	@survey ||= Survey.find(id)
    if params[:index].nil?
  	 @survey_section ||= @survey.sections.where(idx: 1).first
    else
      @survey_section ||= @survey.sections.where(idx: params[:index]).first
    end
  end

  def stats
    @survey = Survey.find(params[:survey_id])
    @questions = Question.where(survey_section_id: @survey.sections.ids)
    @answers = {}

    # Return all question ids for survey:
    qs = @questions.ids
    # Return all user ids who have answered those questions:
    us = Answer.where(question_id: qs).distinct.pluck(:user_id)
    @users = User.find(us)

    #Get answers for each user
    us.each {|u| @answers[u] = Answer.where(user_id: us, question_id: qs).index_by(&:question_id)}

=begin

    #Get all answers
    ans_query = Answer.where(user_id: us, question_id: qs).select(:user_id, :question_id, :answer_text)

    #Map answers to array
    ans_query.map do |ans|
      @answers[ans.user_id][ans.question_id] ||= []
      @answers[ans.user_id][ans.question_id] << ans.answer_text
    end
=end

    respond_to do |format|
      format.html
      format.csv { send_data answers_to_csv(@answers, qs)}
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:name, :description)
  end

  def answers_to_csv(answers, qs, options = {})
    CSV.generate(options) do |csv|
      csv << ["User"].concat(qs)
      answers.each do |uid, questions|
        csv << [uid].concat(qs.map {|qid| questions[qid].join(' ') unless questions[qid].nil?})
      end
    end
  end


end
