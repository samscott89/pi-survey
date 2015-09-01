class SurveysController < ApplicationController

  before_action :authenticate_user!, except: [:show, :index, :finish]
  skip_authorization_check only: [:index, :finish]

  def show
  	@survey = Survey.find(params[:id])

    authorize! :read, @survey

    respond_to do |format|
      format.html {}
      format.json {render json: @survey}
    end
  end

  def index
    @surveys = Survey.accessible_by(current_ability).page(params[:page])
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
    authorize! :create, @survey
  end

  def create
  	@survey = Survey.new(survey_params.merge( owner_id: current_user.id))
    authorize! :create, @survey
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

    @questions = Question.where(survey_section_id: @survey.sections.ids)

    authorize! :edit, @survey

    if params[:index].nil?
  	 @survey_section ||= @survey.sections.where(idx: 1).first
    else
      @survey_section ||= @survey.sections.where(idx: params[:index]).first
    end
  end

  #this is the function that deals with populating the previous question drop down boxes so that particiipants can choose 
  #to use answer options from a previous question. 
  def getdata
    
    #@survey = Survey.find(params[:survey_id])
    #@questions = Question.where(survey_section_id: @survey.sections.ids)
    #@answerOptions = 
    # this contains what has been selected in the first select box
    authorize! :post, @survey

    @data_from_select1 = params[:first_select]


    # we get the data for selectbox 2
    @data_for_select2 = @questions.where(:name => @data_from_select1).all

    # render an array in JSON containing arrays like:
    # [[:id1, :name1], [:id2, :name2]]
    respond_to do |format|
      format.html {}
      format.json {render :json => @data_for_select2.map{|c| [c.id, c.name]}}
    end
    
  end

  def stats
    @survey = Survey.find(params[:survey_id])
    @questions = Question.where(survey_section_id: @survey.sections.ids)
    @ta_type = QuestionType.find_by(name: "text_area").id
    @answers = {}
    @answers_ar = []
    @answers_ar_count = 0
    
    authorize! :stats, @survey

    # Return all question ids for survey:
    qs = @questions.ids
    # Return all user ids who have answered those questions:
    us = Answer.where(question_id: qs).distinct.pluck(:user_id)
    @users = User.find(us)

    #Get answers for each user
    us.each {|u| @answers[u] = Answer.where(user_id: u, question_id: qs).index_by(&:question_id)}
    #NOTE: Might be slow, should change to batch query later.

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
        csv << [uid].concat(qs.map {|qid| questions[qid].nil? ? "" : questions[qid].answer_options.pluck(:answer_text).join(' ') })
      end
    end
  end


end
