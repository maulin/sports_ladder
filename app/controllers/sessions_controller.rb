require 'digest/sha1'
class SessionsController < ApplicationController
  
  def new
  end

  def create
    @current_player = Player.find_by_login_and_password(params[:login], Digest::SHA1.hexdigest(params[:password]))
    if logged_in?
      session[:player_id] = @current_player.id
      redirect_to ladders_path
    else
      render :action => 'new'
    end
  end

  def destroy
		session[:player_id] = @current_player = nil
		flash[:notice] = "Logout successful."
		redirect_to new_session_path
  end

  def forgot_password

  end

  def reset_password
    @player = Player.find(:first, :conditions => ["email = ?", params[:email]])
    if @player.nil?
      flash[:notice] = "That is not a registered email address. Please use the email you used to register."
      redirect_to new_session_path
    else
      @player.updated_password = true
      if @player.update_attributes(:password => "w3lcom3")
				UserMailer.deliver_reset_password(@player)
				flash[:notice] = "#{@player.first_name}, your password has been reset. Your new password has been mailed to you."
				redirect_to new_session_path
      else
				flash[:notice] = "Please try again."
				redirect_to new_session_path
      end
    end
  end
  
end
