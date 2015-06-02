class QuestionsController < ApplicationController


	def create
		@errors = []
		@question = Question.new(question_params)
		@survey_section = SurveySection.find(params[:survey_section])
		@survey = @survey_section.survey  		
		@question.survey_section = @survey_section
		#puts params

	    pending_opt_choices = []


	    if @question.option_group.multiple?
		   	option_params.each do |index, opt|
		      opt_choice = OptionChoice.new(opt.merge(option_group_id: params[:question][:group_id]))
		      pending_opt_choices << opt_choice

		      if !opt_choice.valid?
		        @errors << opt_choice.errors
		        flash[:warning] = "There were errors with your answers: #{option_params}" unless Rails.env.development?
		      end
		    end
		else
			opt_choice = OptionChoice.new(option_group_id: params[:question][:group_id], choice_name: "other")
			pending_opt_choices << opt_choice
			if !opt_choice.valid?
		      @errors << opt_choice.errors
		      flash[:warning] = "There were errors with your answers: #{option_params}" unless Rails.env.development?
		    end
		end

	    if !@question.valid?
	    	@errors << @question.errors
	    	flash[:warning] = "There were errors with your question: #{question_params}" unless Rails.env.development?
	    end

	    if @errors.any?
	      # render 'show'
	      flash[:danger] = "Errors with adding question."
	      redirect_to :back
	    else
	      @question.save
	      pending_opt_choices.each do |opt| 
	      	opt.save
	      	@question.question_options.create(option_choice: opt)
	      end
	      flash[:success] = "Question added."
	      redirect_to survey_edit_section_path(@survey, @survey_section)
	    end
	end

	def update
		@question = params[:question_id]
		@survey_section = SurveySection.find(params[:survey_section])
		@survey = @survey_section.survey  		

		flash[:notice] = params
	    redirect_to survey_edit_section_path(@survey, @survey_section)
	end

	private
	  	  def question_params
	  	  	params.require(:question).permit(:name, :subtext, :required, :group_id)
	  	  end

	  	  def option_params
	  	  	params.require(:option_choice)
	  	  end
end