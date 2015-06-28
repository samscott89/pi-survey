class ParticipantsController < ApplicationController
	before_action :authenticate_user!

	# Since participants are a nested resource of Campaign
	# Simply delegate the authorisation to the parent Campaign
	load_resource :campaign
	load_and_authorize_resource :participant, :through => :campaign

	def index
		@campaign = Campaign.find(params[:campaign_id])
		@participants = @campaign.participants
	end

end
