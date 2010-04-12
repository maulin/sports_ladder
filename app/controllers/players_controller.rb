class PlayersController < ApplicationController
  
  def new
    @player = Player.new
    count = SpamQuestions.count
    rand_quest_id = rand(count)
    rand_quest_id = 1 if rand_quest_id == 0
    @spam = SpamQuestions.find(rand_quest_id)
  end

  def create
    @player = Player.new(params[:player])
    password = @player.password
    question = params[:question]
    answer = params[:answer]
    @spam = SpamQuestions.find(:first, :conditions => ["question = ?", question])
    if @spam.answer == answer.downcase
      if @player.save
	UserMailer.deliver_registration_confirmation(@player, password)
	flash[:notice] = "Registration Sucessfull!"
	redirect_to new_session_path
      else
	render :action => :new
      end
    else
      flash[:notice] = "Incorrect answer. Please try again"
      redirect_to new_player_path
    end
  end

def show
  @player = Player.find(@current_player.id)
  @ladders = @player.ladders
  @challenges = Challenge.find(:all, :order => "created_at DESC",
  :conditions => "(challenger_id = #{@player.id} or defender_id = #{@player.id})
  and score is NULL", :include => [:challenger, :defender, :ladder])
end

def edit
  @player = Player.find(params[:id])
  count = SpamQuestions.count
  rand_quest_id = rand(count)
  rand_quest_id = 1 if rand_quest_id == 0
  @spam = SpamQuestions.find(rand_quest_id)
end

	def update
		@player = Player.find(@current_player.id)
		password = @player.password
		if params[:player][:password] != password
		  @player.updated_password = true
		else
		  @player.updated_password = false
		end
		
		question = params[:question]
		answer = params[:answer]
		@spam = SpamQuestions.find(:first, :conditions => ["question = ?", question])
		if @spam.answer == answer.downcase
			if @player.update_attributes(params[:player])
		  	flash[:notice] = "Personal information updated sucessfully."
		  	redirect_to player_path(@current_player)
			else
		  	render :action => :edit
			end
		else
			flash[:notice] = "Incorrect answer. Please try again"
			render :action => :edit
		end
	end

  def show_stats
    @ladder = Ladder.find(params[:ladder_id])
    @stats = Statistic.find(:first, :conditions => "player_id = #{@current_player.id} and ladder_id = #{params[:ladder_id]}")
    m = Challenge.find_by_sql("select count(*) m from challenges where ladder_id = #{@ladder.id} and 
    (challenger_id = #{@current_player.id} or defender_id = #{@current_player.id}) and winner_id is not null")
    @matches = m[0].m
    w = Challenge.find_by_sql("select count(*) w from challenges where 
    ladder_id = #{@ladder.id} and winner_id = #{@current_player.id}")
    @matches_won = w[0].w
    l = Challenge.find_by_sql("select count(*) l from challenges where ladder_id = #{@ladder.id} and 
    (challenger_id = #{@current_player.id} or defender_id = #{@current_player.id}) and 
    winner_id != #{@current_player.id}")
    @matches_lost = l[0].l
    c = Challenge.find_by_sql("select count(*) c from challenges where ladder_id = #{@ladder.id} and 
    challenger_id = #{@current_player.id}")
    @tot_challenges = c[0].c
    cw = Challenge.find_by_sql("select count(*) cw from challenges where ladder_id = #{@ladder.id} and 
    challenger_id = #{@current_player.id} and winner_id = #{@current_player.id}")
    @challenges_won = cw[0].cw
    d = Challenge.find_by_sql("select count(*) d from challenges where ladder_id = #{@ladder.id} and 
    defender_id = #{@current_player.id}")
    @tot_defences = d[0].d
    dw = Challenge.find_by_sql("select count(*) dw from challenges where ladder_id = #{@ladder.id} and 
    defender_id = #{@current_player.id} and winner_id = #{@current_player.id}")
    @defences_won = dw[0].dw
  end

end
