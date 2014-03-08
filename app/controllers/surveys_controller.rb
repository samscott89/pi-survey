class SurveysController < ApplicationController
  def show
  	@survey = Survey.find(params[:id])
  	@first_section = @survey.sections.first
  end

  def index
  	@surveys = Survey.paginate(page: params[:page])
  end

  def finish
  end
end
