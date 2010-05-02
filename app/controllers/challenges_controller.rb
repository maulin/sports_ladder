class ChallengesController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy]
  
  def index
    if !params[:ladder_id].nil?
      @ladder = Ladder.find(params[:ladder_id])
      page = params[:page]
      @challenges = Challenge.ladder_challenges(@ladder.id, page)
    elsif !params[:player_id].nil?
      player_id = params[:player_id]
      ladder_id = params[:ladder]
      page = params[:page]
			@challenges = Challenge.player_challenges(player_id, ladder_id, page)
    end
  end

  def new
		now = Date.today
    @challenge = Challenge.new
    @ladder = Ladder.find(params[:ladder_id])
    @challenger_stat = Statistic.find(:first, 
			:conditions => "ladder_id = #{@ladder.id} 
    	and player_id = #{@current_player.id}")
    @challenger = @challenger_stat.player
    
    if @challenger_stat.current_rank != 0
      @stats = Statistic.find(:all, 
      :conditions => "ladder_id = #{@ladder.id} 
		      and current_rank < #{@challenger_stat.current_rank} 
		      and current_rank >= #{@challenger_stat.current_rank - @ladder.rungs}
		      and player_id != #{@current_player.id}
		      and is_challenged = 0
					and current_rank != 0
					and str_to_date('#{Date.today}', '%Y-%m-%d') >= 
					case last_chal_player_id when #{@current_player.id} then cooldown_dt else '2000-01-01' end", 
      :include => [:player])
    else
      @stats = Statistic.find(:all, :conditions => "ladder_id = #{@ladder.id} 
						    and player_id != #{@current_player.id}
						    and is_challenged = 0
						    and current_rank != 0", :include => [:player])
    end

    @players = []
    if @challenger_stat.is_challenged == 0
      @stats.each do |s|
	    @players.push(s.player)
      end
    end


    if @challenger_stat.is_penalized == 1
      pd = @challenger_stat.penalized_date.to_date
      d = (pd - DateTime.now.beginning_of_day).to_i
      @msg = "You have been penalized, you cannot issue challenges for #{d+1} days"
    end
  

  end
  
  def create
    @ladder = Ladder.find(params[:ladder_id])
		expire_page :controller=> "ladders", :action => :show, :id => @ladder.id
    @challenger_stat = Statistic.find(:first, 
    :conditions => "ladder_id = #{@ladder.id} 
		    and player_id = #{@current_player.id}")
    @defender_stat = Statistic.find(:first, 
    :conditions => "ladder_id = #{@ladder.id} 
		    and player_id = #{params[:challenge][:defender_id]}")
    @challenger = Player.find(@challenger_stat.player_id)
    @defender = Player.find(@defender_stat.player_id)

    if @ladder.challenge_time_limit.nil? or @ladder.challenge_time_limit == 0
      chal_end_date = nil
    else
      chal_end_date = DateTime.now + @ladder.challenge_time_limit.days
    end

    if Challenge.create(
      :challenger_id => @current_player.id,
      :defender_id => params[:challenge][:defender_id],
      :ladder_id => @ladder.id,
      :challenge_end_date => chal_end_date)
      @challenger_stat.update_attribute(:is_challenged, 1)
      @defender_stat.update_attribute(:is_challenged, 1)

      UserMailer.deliver_challenger_challenge_issued(@challenger, @defender, @ladder)
      UserMailer.deliver_defender_challenge_issued(@challenger, @defender, @ladder)

      flash[:notice] = "Challenge created sucessfully"
    else
      flash[:notice] = "Challenge created sucessfully"
    end
    redirect_to ladder_path(@ladder.id)

    clear_cache(@ladder)    
  end

  def edit
    @challenge = Challenge.find(params[:id], :include => [:ladder, :challenger, :defender])
    @players=[]
    @players.push(@challenge.defender)
    @players.push(@challenge.challenger)
  end

  def update
    @ladder = Ladder.find(params[:ladder_id])
		expire_page :controller=> "ladders", :action => :show, :id => @ladder.id
    @challenge = Challenge.find(params[:id])
    chal_stat = Statistic.find(:first, :conditions => "player_id = #{@challenge.challenger_id} and ladder_id = #{@ladder.id}")
    def_stat = Statistic.find(:first, :conditions => "player_id = #{@challenge.defender_id} and ladder_id = #{@ladder.id}")
    mr = Statistic.find_by_sql("select max(current_rank) mr from statistics where ladder_id = #{@ladder.id}")
    max_rank = mr[0].mr.to_i
    players_move_down = Statistic.find(:all, :conditions => "ladder_id = #{@ladder.id} and current_rank >= #{def_stat.current_rank}")
    winner = Player.find(params[:challenge][:winner_id])
		cool = Date.today + @ladder.cooldown.days
		score = ''
		@ladder.best_of.times do |i|
			if !params[:w][i].blank?
				score = score + params[:w][i] + '/' + params[:l][i] + '(' + params[:t][i] + ') '
			end
		end

    if Challenge.update(params[:id], {:score => score, :winner_id => params[:challenge][:winner_id]})
      
      Statistic.update(chal_stat.id, {:last_chal_player_id => def_stat.player_id, :is_challenged => 0, :cooldown_dt => cool})
      Statistic.update(def_stat.id, {:last_chal_player_id => chal_stat.player_id, :is_challenged => 0, :cooldown_dt => cool})
      if chal_stat.current_rank == 0
				if winner.id == chal_stat.player_id
	  			players_move_down.each do |p|
	    			Statistic.update(p.id, {:current_rank => (p.current_rank + 1)})
	    			if p.lowest_rank == p.current_rank
	      			Statistic.update(p.id, {:lowest_rank => (p.current_rank + 1)})
	    			end
	  			end
	  			Statistic.update(chal_stat.id, {:current_rank => def_stat.current_rank, 
	  			:highest_rank => def_stat.current_rank, :lowest_rank=> def_stat.current_rank})
				else
	  			Statistic.update(chal_stat.id, {:current_rank => (max_rank + 1), 
	  			:highest_rank => (max_rank + 1), :lowest_rank => (max_rank + 1)})
				end
     	else
				if winner.id == chal_stat.player_id
	  			Statistic.update(chal_stat.id, {:current_rank => def_stat.current_rank})
	  			Statistic.update(def_stat.id, {:current_rank => chal_stat.current_rank})
	  			if def_stat.lowest_rank < chal_stat.current_rank
	    			Statistic.update(def_stat.id, {:lowest_rank => chal_stat.current_rank})
	  			end
	  			if chal_stat.highest_rank > def_stat.current_rank
	    		Statistic.update(chal_stat.id, {:highest_rank => def_stat.current_rank})
	  			end	  
				end
      end
	
      flash[:notice] = "Score scuessfully submitted."
      redirect_to player_path(@current_player.id)
    else
      flash[:notice] = "Score submission failed. Please try again."
			redirect_to player_path(@current_player.id)
    end

    clear_cache(@ladder)
  end

  def destroy
    challenge = Challenge.find(params[:id])
    chal_stat = Statistic.find(:first, 
    :conditions => "player_id = #{challenge.challenger_id} and ladder_id = #{challenge.ladder_id}")
    def_stat = Statistic.find(:first, 
    :conditions => "player_id = #{challenge.defender_id} and ladder_id = #{challenge.ladder_id}")
    @challenger = Player.find(challenge.challenger_id)
    @defender = Player.find(challenge.defender_id)
    @ladder = Ladder.find(challenge.ladder_id)
    clear_cache(@ladder)

    Statistic.update(chal_stat.id, {:is_challenged => 0})
    Statistic.update(def_stat.id, {:is_challenged => 0})
    Challenge.delete(challenge.id)
    UserMailer.deliver_cancel_challenge(@challenger, @defender, @ladder)
    
    #flash[:notice] = "Challenge deleted."
    #redirect_to ladder_path(@ladder)
		redirect_to ladder_path(@ladder)

  end

end
