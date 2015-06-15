class SurveySectionsController < ApplicationController

  before_action :authenticate_user!, except: [:show, :answer]
  
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

    authorize! :read, @survey

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

    authorize! :answer, @survey

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
      if @answers[ans[:question_id].to_i].nil?
        a = Answer.new(ans)
        @answers[ans[:question_id].to_i] = a
      else
        a = Answer.find_by(question_id: ans[:question_id], user_id: ans[:user_id])
        a.assign_attributes(ans)
        @answers[ans[:question_id].to_i] = a
      end
      # puts "----- Question: #{ans[:question_id]} -----"
      # puts ans
      # puts a.to_json
      # puts a.answer_options.to_json
      if !a.valid?
        # puts "Errors with answer: #{a.to_json} with options: #{a.answer_options.to_json}"
        # puts a.errors.to_json
        @errors << a.errors
      end
      pending_answers << a
    end
    
    if @errors.any? 
      flash.now[:error] = "There were errors with your answers."
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

    authorize! :edit, @survey

    @survey_section.assign_attributes(survey_section_params)
    if @survey_section.save
      flash.now[:success] = "Changed"
    else
      flash.now[:error] = "Could not change"
    end 


    respond_to do |format|
      format.json {render json: @survey_section}
    end
  end

  def new
    @survey = Survey.find(params[:survey_id])
    authorize! :edit, @survey

    idx = (@survey.sections.pluck(:idx) << 0).max + 1
    @section = @survey.sections.create(name: "Section #{idx}", title: "New Section", idx: idx)
    flash[:success] = "Section added."

    redirect_to edit_survey_path(@survey, index: idx)
  end

  def delete
    @survey = Survey.find(params[:survey_id])
    @survey_section = @survey.sections.where(idx: params[:index]).first
    authorize! :destroy, @survey

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
        # I don't know why this is needed :*(
        # For some reason without this these are hashes and not StrongParamters D:
        ans = params[:answers][q.id.to_s]
        
      end

      answer_params = []
      params.require(:answers).each do |qid, pa|
        answer_params << pa.permit(:question_id, :answer_text, :has_other, answer_options_attributes: [:id, :option_id, :answer_text]).merge(user_id: user.id)
      end

      answer_params
    end


    def survey_section_params
      params.require(:survey_section).permit(:name, :title, :required, :index)
    end
end
