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

  private

  def survey_params
    params.require(:survey).permit(:name, :description)
  end


end
