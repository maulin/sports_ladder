class UserMailer < ActionMailer::Base
  def registration_confirmation(player, password)
    recipients		player.email
    from		"admin@sl.maulinpathare.com"       
    subject		"Sports Ladder registration"
    body		:player => player, :password => password
  end

  def challenger_challenge_issued(challenger, defender, ladder)
    recipients		challenger.email
    from		"admin@sl.maulinpathare.com"       
    subject		"Challenge notification"
    body		:challenger => challenger, :defender => defender, :ladder => ladder
  end

  def defender_challenge_issued(challenger, defender, ladder)
    recipients		defender.email
    from		"admin@sl.maulinpathare.com"       
    subject		"Challenge notification"
    body		:challenger => challenger, :defender => defender, :ladder => ladder
  end

  def cancel_challenge(challenger, defender, ladder)
    recipients		[defender.email, challenger.email]
    from		"admin@sl.maulinpathare.com"       
    subject		"Challenge cancelled"
    body		:challenger => challenger, :defender => defender, :ladder => ladder
  end

  def reset_password(player, reset_pass)
    recipients		player.email
    from		"admin@sl.maulinpathare.com"       
    subject		"Password reset request"
    body		:player => player, :reset_pass => reset_pass
  end

  def new_comment(commenter, player, ladder, comment)
    recipients		player.email
    from		"admin@sl.maulinpathare.com"       
    subject		"New comment"
    body		:player => player, :comment => comment, :ladder => ladder, :commenter => commenter
  end
end
