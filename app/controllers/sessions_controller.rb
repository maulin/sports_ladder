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
    @player = Player.find(:first, :conditions => ["login = ?", params[:login]])
    if @player.nil?
      flash[:notice] = "That is not a registered email address. Please use the email you used to register."
      redirect_to new_session_path
    else
      @player.updated_password = true
      @reset_pass = ""
      8.times do |i|
        @reset_pass += ("a".."z").to_a[rand(26)]
      end
      if @player.update_attributes(:password => "#{@reset_pass}")
				UserMailer.deliver_reset_password(@player, @reset_pass)
				flash[:notice] = "#{@player.first_name}, your password has been reset. Your new password has been mailed to you."
				redirect_to new_session_path
      else
				flash[:notice] = "Please try again."
				redirect_to new_session_path
      end
    end
  end
  
end
