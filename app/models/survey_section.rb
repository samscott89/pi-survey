class SurveySection < ActiveRecord::Base
	acts_as_paranoid
	
	validates :name, presence: true
	validates :title, presence: true
	# validates :required, presence: true

	belongs_to :survey, inverse_of: :sections
	validates_presence_of :survey
	
	has_many :questions, dependent: :destroy

	after_destroy :remove_idx

	def remove_idx
		self.idx = nil
  	end
end
