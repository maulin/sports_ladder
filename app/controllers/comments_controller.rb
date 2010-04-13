class CommentsController < ApplicationController
	before_filter :login_required, :only => [:new, :create]

	def index
		#@comments = Comment.find(:all, :conditions=>"ladder_id = #{params[:ladder_id]}", :order=>"created_at DESC", :limit => 20)
		@comments = Comment.paginate(:per_page => 10, :page => params[:page], 
		:conditions=>"ladder_id = #{params[:ladder_id]}", :order=>"created_at DESC", :limit => 20)
		@ladder = Ladder.find(params[:ladder_id])
	end		

	def new
		@comment = Comment.new
		@ladder = Ladder.find(params[:ladder_id])
		count = SpamQuestions.count
		rand_quest_id = rand(count)
		rand_quest_id = 1 if rand_quest_id == 0
		@spam = SpamQuestions.find(rand_quest_id)
		statistic = player_ladder(@ladder)
		if statistic.nil?
			redirect_to ladder_path(@ladder.id)
			flash[:notice] = "You need to join this ladder before posting."
		end
	end

	def edit
		@comment = Comment.find(params[:id])
		@ladder = Ladder.find(@comment.ladder_id)
		count = SpamQuestions.count
		rand_quest_id = rand(count)
		rand_quest_id = 1 if rand_quest_id == 0
		@spam = SpamQuestions.find(rand_quest_id)
	end

def update
		@comment = Comment.find(params[:id])
		@ladder = Ladder.find(@comment.ladder_id)
		question = params[:question]
		answer = params[:answer]
		@spam = SpamQuestions.find(:first, :conditions => ["question = ?", question])
		if @spam.answer == answer.downcase
			if @comment.update_attributes(params[:comment])
		  	flash[:notice] = "Comment updated sucessfully."
		  	redirect_to ladder_comments_path(@ladder.id)
			else
		  	render :action => :edit
			end
		else
			flash[:notice] = "Incorrect answer. Please try again"
			render :action => :edit
		end
	end

  def create
		@ladder = Ladder.find(params[:ladder_id])
		@players = Statistic.find(:all, :conditions => "ladder_id = #{@ladder.id}", :include => [:player])
		@statistic = player_ladder(@ladder)
		question = params[:question]
		answer = params[:answer]
		@spam = SpamQuestions.find(:first, :conditions => ["question = ?", question])
		comment = params[:comment][:comment]
		if @spam.answer == answer.downcase
		  if Comment.create(
		    :player_id => @current_player.id,
		    :ladder_id => @ladder.id,
		    :comment => comment)
		    flash[:notice] = "Post sucessfull."
		    comment = comment.split("\n").join("||")
 		    system "rake send_mailing L=#{@ladder.id} CP=#{@current_player.id} C='#{comment}' >> send_email.log &"
#				@players.each do |p|
#					UserMailer.deliver_new_comment(@current_player, p.player, @ladder, comment)
#				end
		    redirect_to ladder_comments_path(@ladder.id)
		  else
		    flash[:notice] = "Please try again."
		    redirect_to ladder_comments_path(@ladder.id)
		  end
		else
		  flash[:notice] = "Incorrect answer. Please try again."
		  redirect_to new_ladder_comment_path(@ladder.id)
		end
	end

end
