require 'pp'

desc "Cancels challenges that have not been played for 10 days"
task :cancel_outstanding_challenge => :environment do
  oc = Challenge.find(:all, :conditions => "challenge_end_date = str_to_date('#{DateTime.now.strftime('%m%d%y')}', '%m%d%y')")
  
  oc.each do |c|
    chal_stat = Statistic.find(:first, :conditions => "player_id = #{c.challenger_id} and ladder_id = #{c.ladder_id}")
    def_stat = Statistic.find(:first, :conditions => "player_id = #{c.defender_id} and ladder_id = #{c.ladder_id}")
    Statistic.update(chal_stat.id, {:is_challenged => 0, :is_penalized => 1, :penalized_date => DateTime.now + 5.days})
    Statistic.update(def_stat.id, {:is_challenged => 0, :is_penalized => 1, :penalized_date => DateTime.now + 5.days})
    Challenge.delete(c.id)
  end

end

desc "Removes penalty if penalty end date is today"
task :remove_penalty => :environment do
  pplayer = Statistic.find(:all, :conditions => "penalized_date = str_to_date('#{DateTime.now.strftime('%m%d%y')}', '%m%d%y')")
  
  pplayer.each do |p|
    p.is_penalized = 0
    p.penalized_date = nil
    p.save
  end
end
  
desc "send email when new comment is added"
task :send_mailing => :environment do

  current_player_id = ENV['CP']
  ladder_id = ENV['L']
  comment = ENV['C']
  comment = comment.gsub("||", "\n")
  
  current_player = Player.find(current_player_id)
  players = Statistic.find(:all, :conditions => "ladder_id = #{ladder_id}", :include => [:player])

  players.each do |p|
  	UserMailer.deliver_new_comment(current_player, p.player, ladder, comment)
	end
    
end
  

