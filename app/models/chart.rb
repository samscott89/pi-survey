class Chart < ActiveRecord::Base
	belongs_to :chart_type, foreign_key: "type_id"
	belongs_to :question
end
