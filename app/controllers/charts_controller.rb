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
    @survey = Survey.find(params[:survey_id])
    @questions = @survey.questions

    @answers = {}
    @answers_ar = []
    @answers_ar_count = 0

    @chart = Chart.where(question_id: @questions.pluck(:id)).last

    # Aggregate data for question
    # Currently just count entries. But this should be changed to
    # something more sophisticated.
    unless @chart.nil?
      if @chart.chart_type == ChartType.find_by(name: 'line_chart')
        qs = Question.where(id: [@chart.question_id, @chart.question_id2, @chart.question_id3])
        @stats = qs.map {|q|
          {name: q.name, data: Answer.joins(:answer_options).where(question_id: q.id).group("answer_options.answer_text").count}
        }
      else
        @stats = Answer.joins(:answer_options).where(question_id: @chart.question_id).group("answer_options.answer_text").count
      end
    end 
  end

	private

	def chart_params
    	params.require(:chart).permit(:id, :type_id, :question_id, :question_id2, :question_id3)
  	end
end