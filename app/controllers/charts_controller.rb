class ChartsController < ApplicationController

  before_action :authenticate_user! 
  # Delegate authorisation to the parent survey
  load_and_authorize_resource :survey


  def new
	@chart = Chart.new
	@survey = Survey.find(params[:survey_id])
    @questions = Question.where(survey_section_id: @survey.sections.ids)
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @chart = Chart.new(chart_params)
    if !@chart.valid?
        redirect_to :back, alert: "Error creating chart." 
    else
    	@chart.save
      redirect_to survey_charts_path(@survey), survey_id: params[:survey_id]
    end
  end

  def index
    @chart_types = ChartType.all
    @survey = Survey.find(params[:survey_id])
    @questions = @survey.questions

    @answers = {}
    @answers_ar = []
    @answers_ar_count = 0

    @chart = Chart.where(question_id: @questions.pluck(:id)).last


    # Aggregate data for question
    # Currently just count entries. But this should be changed to
    # something more sophisticated.
    @question = Question.find(@chart.question_id)
   	@stats = Answer.joins(:answer_options).where(question_id: @question.id).group("answer_options.answer_text").count

  end

	private

	def chart_params
    	params.require(:chart).permit(:id, :type_id, :question_id)
  	end
end