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
  end

  def new
    @survey = Survey.new
  end

  def create
  	@survey = Survey.new(survey_params)
    if @survey.save
      flash[:success] = "Survey Created"
       @survey.sections.create(name: "Section 1", title: "New Section", index: 1)
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
  	 @survey_section ||= @survey.sections.where(index: 1).first
    else
      @survey_section ||= @survey.sections.where(index: params[:index]).first
    end
  end

  def stats
    @survey = params[:survey_id]
    @questions = Questions.where(survey_section_id: @survey.sections.ids)
    @answers = {}

    # Return all question ids for survey:
    qs.ids
    # Return all user ids who have answered those questions:
    us = Answer.joins(:question_option).where("question_options.question_id" => qs).distinct.pluck(:user_id)

    #Initialise hash
    us.each {|u| @answers[u] = {}}

    #Get all answers
    ans_query = Answer.joins(:question_option).where(user_id: us).select("answers.user_id, question_options.question_id, answers.answer_text")

    #Map answers to array
    ans_query.map do |ans|
      @answers[ans.user_id][ans.question_id] ||= []
      @answers[ans.user_id][ans.question_id] << ans.answer_text
    end

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
      csv << qs
      answers.each do |ans|
        ans.each do |uid, questions|
        csv << [uid].concat qs.map {|qid| questions[qid].join(' ')}
      end
    end
  end


end
