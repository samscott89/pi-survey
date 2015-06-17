class Participant < ActiveRecord::Base
	belongs_to :user
	belongs_to :campaign

	validates_presence_of :user
	validates_presence_of :campaign
end
