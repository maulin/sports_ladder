class StatisticsController < ApplicationController
before_filter :login_required, :only => [:create]
	
	def create
		@ladder = Ladder.find(params[:ladder_id])
		if Statistic.create(
			:player_id => @current_player.id,
			:ladder_id => params[:ladder_id],
			:highest_rank => 0,
			:lowest_rank => 0,
			:current_rank => 0,
			:is_challenged => 0,
			:last_chal_player_id => 0,
			:role => 0)
			redirect_to ladders_path
			flash[:notice] = "You have joined the ladder: #{@ladder.name}."
		else
			flash[:notice] = "Could not join ladder, try again."
		end

    clear_cache(@ladder)
	end

end
