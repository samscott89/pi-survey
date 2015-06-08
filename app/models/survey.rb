class Survey < ActiveRecord::Base
	validates :name, presence: true
	has_many :sections, class_name: "SurveySection"
	belongs_to :owner, class_name: "User"
end
