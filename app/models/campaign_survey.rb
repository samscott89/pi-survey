class CampaignSurvey < ActiveRecord::Base
	belongs_to :campaign
	belongs_to :survey

	validates_presence_of :campaign
	validates_presence_of :survey
	
end
