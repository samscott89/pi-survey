class Campaign < ActiveRecord::Base
	has_many :surveys, through: :campaign_surveys
	has_one :owner, foreign_key: :user_id
	has_many :participants
	has_many :users, through: :participants

	has_many :campaign_surveys

	accepts_nested_attributes_for :campaign_surveys

	validates_presence_of :owner
end
