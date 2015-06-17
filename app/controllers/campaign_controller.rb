class CampaignController < ApplicationController
	before_action :authenticate_user!

	def new
	  @campaign = Campaign.new
	  authorize! :create, @campaign
	end

	def create
	  @campaign = Campaign.new(campaign_params)
	  authorize! :create, @campaign
	  if @campaign.save
	    flash[:notice] = "Campaign created."
	  else
	    flash.now[:fail] = "Error creating campaign."
	    render 'new'
	  end
	end
	
	def index
	  @campaigns = Campaign.accessible_by(current_ability).page(params[:page])
	end
	
	def show
	  @campaign = Campaign.find(params[:id])

	  authorize! :read, @campaign

	  respond_to do |format|
	    format.html {}
	  end
	end

end
