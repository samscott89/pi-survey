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
		        flash[:error] = "There were errors with your answers: #{option_params}"
		      end
		    end
		else
			opt_choice = OptionChoice.new(option_group_id: params[:question][:group_id], choice_name: "other")
			pending_opt_choices << opt_choice
			if !opt_choice.valid?
		      @errors << opt_choice.errors
		      flash[:error] = "There were errors with your answers: #{option_params}"
		    end
		end

	    if !@question.valid?
	    	@errors << @question.errors
	    	flash[:error] = "There were errors with your question: #{question_params}"
	    end

	    if @errors.any?
	      # render 'show'
	      flash[:error] = "Errors with adding question."
	      redirect_to :back
	    else
	      @question.save
	      pending_opt_choices.each do |opt| 
	      	opt.save
	      	@question.question_options.create(option_choice: opt)
	      end
	      flash[:success] = "Question added."
	      redirect_to survey_edit_section_path(@survey, @survey_section.index)
	    end
	end

	def update
		@question = Question.find(params[:id])
		@survey_section = SurveySection.find(params[:survey_section])
		@survey = @survey_section.survey
		pending_new = []
		pending_updates = []
		@errors = []

		was_multiple = @question.option_group.multiple?

		@question.assign_attributes(question_params)

	    if @question.option_group.multiple?

	    	#Update all the existing records
		   	update_option_params.each do |index, opt|
    		  opt_choice = OptionChoice.find(opt[:id])
    		  opt_choice.assign_attributes({choice_name: opt[:choice_name]})
 		      pending_updates << opt_choice

		      if !opt_choice.valid?
		        @errors << opt_choice.errors
		        flash[:error] = "There were errors with your answers: #{option_params}"
		      end
		    end

		    #Create the new options
		    option_params.each do |index, opt|
		      next if opt[:choice_name].empty?
		      opt_choice = OptionChoice.new(opt.merge(option_group_id: params[:question][:group_id]))
		      pending_new << opt_choice

		      if !opt_choice.valid?
		        @errors << opt_choice.errors
		        flash[:error] = "There were errors with your answers: #{option_params}"
		      end
		    end
		else
			opt_choice = OptionChoice.new(option_group_id: params[:question][:group_id], choice_name: "other")
			pending_new << opt_choice
			if !opt_choice.valid?
		      @errors << opt_choice.errors
		      flash[:error] = "There were errors with your answers: #{option_params}"
		    end
		end

		if !@question.valid?
			@errors << @question.errors
			flash[:error] = "There were errors with your question: #{question_params}"
		end

		if @errors.any?
		  # render 'show'
		  flash[:error] = "Errors with updating question."
		  redirect_to :back
		else
		  # This gets rid of old answers when switching from multiple=>single answer and vice-versa.
		  if @question.option_group.multiple? != was_multiple
		  	@question.question_options.destroy_all
		  end
		  @question.save
		  pending_updates.each do |opt| 
		  	opt.save
		  end
		  pending_new.each do |opt|
		  	opt.save
		  	@question.question_options.create(option_choice: opt)
		  end
		  flash[:success] = "Question updated."
		  redirect_to survey_edit_section_path(@survey, @survey_section.index)
		end
	end

	private
	  	  def question_params
	  	  	params.require(:question).permit(:name, :subtext, :required, :group_id)
	  	  end

	  	  def option_params
	  	  	params.require(:option_choice)
	  	  end

	  	  def update_option_params
	  	  	if params[:question].has_key? :option_choices_attributes
		  	  	params.require(:question).require(:option_choices_attributes) 
		  	else
		  		[]
		  	end
	  	  end
end