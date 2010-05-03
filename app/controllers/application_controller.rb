# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '27f6037731f0eacabc458d1f94212168'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

	before_filter :fetch_logged_in_player
	filter_parameter_logging :password

	protected

	def fetch_logged_in_player
		if session[:player_id]
			#find_by_id used instead of find because find displays an error if id is not found. find_by_id exits gracefully.
			@current_player = Player.find_by_id(session[:player_id])
		end
	end
	
	def login_required
		return true if logged_in?
		flash[:notice] = "Login required to complete specified action."
		redirect_to new_session_path and return false
	end

	def logged_in?
		! @current_player.nil?
	end

	def player_ladder(ladder)
		if logged_in?
			return Statistic.find(:first, :conditions=>"ladder_id = #{ladder.id} and player_id = #{@current_player.id}")
		else
			return nil
		end
	end

	helper_method :logged_in?, :player_ladder

end
