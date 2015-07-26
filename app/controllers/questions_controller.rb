class QuestionsController < ApplicationController

	before_action :authenticate_user!

	def create
		@errors = []
		@survey_section = SurveySection.find(params[:survey_section])
		@survey = @survey_section.survey  		
		@question = Question.new(question_params.merge(survey_section: @survey_section))
		#puts params

		authorize! :edit, @survey

	    if !@question.valid?
	      # render 'show'
	      flash[:error] = "Errors with adding question."
	      redirect_to :back
	    else
	      @question.save
	      flash[:success] = "Question added."
	      redirect_to survey_edit_section_path(@survey, @survey_section.idx)
	    end
	end

	def update
		@question = Question.find(params[:id])
		@survey_section = SurveySection.find(params[:survey_section])
		@survey = @survey_section.survey
		

		authorize! :edit, @survey
		was_multiple = @question.question_type.is_multiple?
		@question.assign_attributes(question_params)

		if !@question.valid?
		  # render 'show'
		  flash[:error] = "Errors with updating question."
		  redirect_to :back
		else
		  # This gets rid of old answers when switching from multiple=>single answer and vice-versa.
		 @question.save
		  flash[:success] = "Question updated."
		  redirect_to survey_edit_section_path(@survey, @survey_section.idx)
		end
	end

	def destroy
		@question = Question.find(params[:id])
		@question.destroy

		authorize! :edit, @survey

		redirect_to :back
	end

	private
	  	  def question_params
	  	  	params.require(:question).permit(:name, :subtext, :required, :allow_other,
	  	  		option_group_attributes: [:type_id, 
	  	  			option_choices_attributes: [:choice_name, :_destroy]])
	  	  end

end