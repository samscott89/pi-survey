class SurveySection < ActiveRecord::Base
	include NotDeleteable
	
	validates :name, presence: true
	validates :title, presence: true
	# validates :required, presence: true

	belongs_to :survey, inverse_of: :sections
	validates_presence_of :survey
	
	has_many :questions, dependent: :destroy

	def destroy
		self.idx = nil
	    self.update_attribute :deleted, true
  	end
end
