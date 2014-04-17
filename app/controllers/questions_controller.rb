class QuestionsController < ApplicationController


	def create
		@errors = []
		@question = Question.new(question_params)  			  		
		@question.survey_section = SurveySection.find(params[:survey_section])
		puts params

	    pending_opt_choices = []


	    if @question.option_group.multiple?
		   	option_params.each do |index, opt|
		      opt_choice = OptionChoice.new(opt.merge(option_group_id: params[:question][:group_id]))
		      pending_opt_choices << opt_choice

		      if !opt_choice.valid?
		        @errors << opt_choice.errors
		        flash.now[:fail] = "There were errors with your answers: #{option_params}"
		      end
		    end
		else
			opt_choice = OptionChoice.new(option_group_id: params[:question][:group_id], choice_name: "other")
			pending_opt_choices << opt_choice
			if !opt_choice.valid?
		      @errors << opt_choice.errors
		      flash.now[:fail] = "There were errors with your answers: #{option_params}"
		    end
		end

	    if !@question.valid?
	    	@errors << @question.errors
	    	flash.now[:fail] = "There were errors with your question: #{question_params}"
	    end


	    if @errors.any?
	      # render 'show'
	      redirect_to survey_edit_section_path(@question.survey_section.survey, @question.survey_section), notice: "Errors with adding question."
	    else
	      @question.save
	      pending_opt_choices.each do |opt| 
	      	opt.save
	      	@question.question_options.create(option_choice: opt)
	      end
	      redirect_to survey_edit_section_path(@question.survey_section.survey, @question.survey_section), notice: "Question added."
	    end
	end

	private
	  	  def question_params
	  	  	params.require(:question).permit(:name, :subtext, :required, :group_id)
	  	  end

	  	  def option_params
	  	  	params.require(:option_choice)
	  	  end
end