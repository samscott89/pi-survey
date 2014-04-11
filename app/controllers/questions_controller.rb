class QuestionsController < ApplicationController


	def create

		@question = Question.new(question_params)  			  		
		@question.survey_section = SurveySection.find(params[:survey_section])
		if @question.save
			flash.now[:success] = "Question added"
		else
		  flash.now[:fail] = "Error creating question"
		end	

	    respond_to do |format|
	      format.js 
		end
	end

	private
	  	  def question_params
	  	  	params.require(:question).permit(:name, :subtext, :required, :group_id)
	  	  end

end