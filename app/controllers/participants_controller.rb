class ParticipantsController < ApplicationController
	before_action :authenticate_user!

	# Since participants are a nested resource of Campaign
	# Simply delegate the authorisation to the parent Campaign
	load_and_authorize_resource :campaign

	def index
		@campaign = Campaign.find(params[:campaign_id])
	    @participants = @campaign.participants.page(params[:page])
	end

	def add
		@campaign = Campaign.find(params[:campaign_id])
		@participants = Participant.new(campaign: @campaign)
	end

	def edit
		@campaign = Campaign.find(params[:campaign_id])
		emails = params[:emails].split(%r{[ ,\r\n"]})
		users = User.where(email: emails).where.not(id: @campaign.participants.pluck(:user_id))

		p users.to_json

		users.each do |u|
			@campaign.participants.build(user: u)
		end

		p @campaign.participants.to_json

		if @campaign.save
		  flash[:notice] = "Participants addded"
		  redirect_to campaign_participants_path(@campaign)
		else
		  flash.now[:fail] = "Error adding participants. #{@campaign.errors.to_json}"
		  render 'add'
		end
	end
end
