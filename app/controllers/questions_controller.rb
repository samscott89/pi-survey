class QuestionsController < ApplicationController

	before_action :authenticate_user!

	def create
		@errors = []
		@survey_section = SurveySection.find(params[:survey_section])
		@survey = @survey_section.survey  		
		@question = Question.new(question_params.merge(survey_section: @survey_section))
		#puts params


		if !@question.option_group.question_type.is_multiple?
			@question.option_group.option_choices.build(choice_name: "Other")
		end

		authorize! :edit, @survey
	    if !@question.valid?
	      # render 'show'
	      flash[:error] = "Errors with adding question."
	      redirect_to :back
	    else
	      @question.save
	      # Questions which have multiple options but should only have
	      # a single answer TODO: move this into the model
	      # added the "if" below as when I ran the code on edits branch, local host, it threw an error saying it expected an end statement
	      if QuestionType.where(name: ["radio_button", "select", "likert_scale"]).ids.include? @question.question_type.id
		  	@question.update(max_answers: 1)
		  else
		  	@question.update(max_answers: @question.option_choices.count)
	      end
	      flash[:success] = "Question added."
	      redirect_to survey_edit_section_path(@survey, @survey_section.idx)
	    end
	end

	def update
		@question = Question.find(params[:id])
		@survey_section = SurveySection.find(params[:survey_section])
		@survey = @survey_section.survey
		

		was_multiple = @question.question_type.is_multiple?
		@question.assign_attributes(question_params)

		authorize! :edit, @survey
		
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
		survey = @question.survey
		
		authorize! :edit, survey
		@question.destroy

		redirect_to :back
	end

	private
	  	  def question_params
	  	  	params.require(:question).permit(:name, :subtext, :required, :allow_other,
	  	  		option_group_attributes: [:type_id, 
	  	  			option_choices_attributes: [:choice_name, :_destroy]])
	  	  end

end