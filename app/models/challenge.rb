class Challenge < ActiveRecord::Base
	belongs_to :challenger, :class_name => 'Player'
	belongs_to :defender, :class_name => 'Player'
	belongs_to :ladder

	def self.validate_score(score, sport, best_of)
		sets = {}
		games = {}

		if sport == "Tennis"
			j = 0
			best_of.times do |i|
				sets[i+1] = score[j..j+2]
				j = j + 3
			end
		end

		if sport == "Racquet Ball"
			j = 0
			best_of.times do |i|
				games[i+1] = score[j..j+1]
				j = j + 2
			end								
		end

	end

end


