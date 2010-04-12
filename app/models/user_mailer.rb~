class UserMailer < ActionMailer::Base
  def registration_confirmation(player, password)
    recipients		player.email
    from		"donotreply@sportsladder.com"       
    subject		"Sports Ladder registration"
    body		:player => player, :password => password
  end

  def challenger_challenge_issued(challenger, defender, ladder)
    recipients		challenger.email
    from		"donotreply@sportsladder.com"       
    subject		"Challenge notification"
    body		:challenger => challenger, :defender => defender, :ladder => ladder
  end

  def defender_challenge_issued(challenger, defender, ladder)
    recipients		defender.email
    from		"donotreply@sportsladder.com"       
    subject		"Challenge notification"
    body		:challenger => challenger, :defender => defender, :ladder => ladder
  end

  def cancel_challenge(challenger, defender, ladder)
    recipients		[defender.email, challenger.email]
    from		"donotreply@sportsladder.com"       
    subject		"Challenge cancelled"
    body		:challenger => challenger, :defender => defender, :ladder => ladder
  end

  def reset_password(player)
    recipients		player.email
    from		"donotreply@sportsladder.com"       
    subject		"Password reset request"
    body		:player => player
  end

  def new_comment(commenter, player, ladder, comment)
    recipients		player.email
    from		"donotreply@sportsladder.com"       
    subject		"New comment"
    body		:player => player, :comment => comment, :ladder => ladder, :commenter => commenter
  end
end
