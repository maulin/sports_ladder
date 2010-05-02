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

def edit
  @player = Player.find(params[:id])
  count = SpamQuestions.count
  rand_quest_id = rand(count)
  rand_quest_id = 1 if rand_quest_id == 0
  @spam = SpamQuestions.find(rand_quest_id)
  session[:back] = request.referer

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
		  	if session[:back]
		  	  redirect_to session[:back]
		  	else
  		  	redirect_to ladders_path
  		  end
			else
		  	render :action => :edit
			end
		else
			flash[:notice] = "Incorrect answer. Please try again"
			render :action => :edit
		end

    system("rm -rf #{RAILS_ROOT}/public/ladders")
	end

end
