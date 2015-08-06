class ChartsController < ApplicationController

	def new
		@chart = Chart.new
		authorize! :create, @chart
	end
	def create
		#this runs but has an authentication check problem. I dont understand this properly. 
	    @chart = Chart.new(chart_params.merge( owner_id: current_user.id))
	    authorize! :create, @chart
	    if !@chart.valid?
	        redirect_to "http://www.rubyonrails.org", alert: "Error creating user." 
	    else
	    	@chart.save
	        redirect_to :back, alert: "Chart created successfully."
	    end
	end
	def destroy
	end

	private

	def chart_params
    	params.require(:chart).permit(:id, :type_id, :question_id)
  	end
end