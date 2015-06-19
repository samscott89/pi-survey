class Campaign < ActiveRecord::Base
	has_many :surveys, through: :campaign_surveys
	belongs_to :owner, class_name: "User"
	has_many :participants
	has_many :users, through: :participants

	has_many :campaign_surveys, inverse_of: :campaign

	accepts_nested_attributes_for :campaign_surveys

	validates_presence_of :user_id
end
