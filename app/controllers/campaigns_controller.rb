class CampaignsController < ApplicationController
	before_action :authenticate_user!

	def new
	  @user = current_user
	  @user_surveys = @user.surveys
	  @campaign = Campaign.new
	  authorize! :create, @campaign
	end

	def create
	  @user = current_user
	  @user_surveys = @user.surveys

	  @campaign = Campaign.new(campaign_params)
	  @campaign.assign_attributes(owner_id: current_user.id)
	  authorize! :create, @campaign
	  if @campaign.save
	    flash[:success] = "Campaign created."
	    redirect_to @campaign
	  else
	    @errors = @campaign.errors
	    flash.now[:error] = "Error creating campaign. #{@errors.to_json}"
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

	def edit
		@user = current_user
		@user_surveys = @user.surveys
		@campaign = Campaign.find(params[:id])
		authorize! :update, @campaign
	end

	def update
		@user = current_user
		@user_surveys = @user.surveys

		@campaign = Campaign.find(params[:id])
		@campaign.assign_attributes(campaign_params)
		authorize! :update, @campaign
		if @campaign.save
		  flash[:success] = "Campaign updated."
		  redirect_to edit_campaign_path @campaign
		else
		  @errors = @campaign.errors
		  flash.now[:error] = "Error updating campaign. #{@errors.to_json}"
		  render 'edit'
		end
	end

	private 

		def campaign_params
			params.require(:campaign).permit(:name, campaign_surveys_attributes: [:id, :survey_id, :start_date, :end_date])
		end
end
