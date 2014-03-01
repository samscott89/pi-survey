class UnitOfMeasurement < ActiveRecord::Base
	has_many :answers, foreign_key: "unit_id"
	validates :name, presence: true
end
