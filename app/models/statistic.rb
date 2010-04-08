class Statistic < ActiveRecord::Base
	belongs_to :ladder
	belongs_to :player
end
