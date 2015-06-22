class CampaignSurvey < ActiveRecord::Base
	belongs_to :campaign, inverse_of: :campaign_surveys
	belongs_to :survey

	validates_presence_of :campaign
	validates_presence_of :survey

	validate :check_survey_owner

	def check_survey_owner
		unless self.survey.owner_id == self.campaign.owner_id
			errors.add(:owner, "Survey must be owned by Campaign owner.")
		end
	end
	
end
