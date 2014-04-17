class SurveysController < ApplicationController
  def show
  	@survey = Survey.find(params[:id])

    respond_to do |format|
      format.html {}
      format.json {render json: @survey}
    end
  end

  def index
  	@surveys = Survey.paginate(page: params[:page])
  end

  def finish
  end

  def new
  	@survey = Survey.new(name: "Survey Title", 
  		instructions: "Write some instructions for your survey here", 
  		description: "A new survey", live: false)

  	@survey_section = SurveySection.new(name: "New Section", title: "New Survey Section", index: 1)
  end

  def edit
    id = params[:survey_id]
    id ||= params[:id]
  	@survey = Survey.find(id)
    if params[:index].nil?
  	 @survey_section = @survey.sections.where(index: 1).first
    else
      @survey_section = @survey.sections.where(index: params[:index]).first
    end
  end

  private


end
