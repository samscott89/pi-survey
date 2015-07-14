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

		@question.assign_attributes(question_params)
=begin

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
=end

		if !@question.valid?
		  1/0
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
	  	  	# params.require(:question).permit(:subtext, :required, option_group: [:question_type, choice_name: []])
	  	  	# params.require(:question).permit(:name, :subtext, :required, :group_id, :allow_other)
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