require 'pp'

desc "Cancels challenges that have not been played for 10 days"
task :cancel_outstanding_challenge => :environment do

  puts "******************************"
  puts Time.now
  
  oc = Challenge.find(:all, :conditions => "challenge_end_date = str_to_date('#{DateTime.now.strftime('%m%d%y')}', '%m%d%y')")
  
  puts "Found #{oc.size} outstanding challenges"
  
  oc.each do |c|
    chal_stat = Statistic.find(:first, :conditions => "player_id = #{c.challenger_id} and ladder_id = #{c.ladder_id}", :include => [:player])
    def_stat = Statistic.find(:first, :conditions => "player_id = #{c.defender_id} and ladder_id = #{c.ladder_id}", :include => [:player])
    Statistic.update(chal_stat.id, {:is_challenged => 0, :is_penalized => 1, :penalized_date => DateTime.now.beginning_of_day + 6.days})
    Statistic.update(def_stat.id, {:is_challenged => 0, :is_penalized => 1, :penalized_date => DateTime.now.beginning_of_day + 6.days})
    Challenge.delete(c.id)
    puts "Challenge id = #{c.id}, Challenge date = #{c.created_at}"
    puts "Challenger = #{chal_stat.player.first_name}, Defender = #{def_stat.player.first_name}"
  end

end

desc "Removes penalty if penalty end date is today"
task :remove_penalty => :environment do

  puts "******************************"
  puts Time.now
  
  pplayer = Statistic.find(:all, :conditions => "penalized_date = str_to_date('#{DateTime.now.strftime('%m%d%y')}', '%m%d%y')", :include => [:player])
  
  puts "Found #{pplayer.size} penalized players"
  
  pplayer.each do |p|
    puts "p.player.first_name was penalized on #{p.penalized_date}"
    p.is_penalized = 0
    p.penalized_date = nil
    p.save
  end
end
  
desc "send email when new comment is added"
task :send_mailing => :environment do

  puts "******************************"
  puts Time.now
  
  current_player_id = ENV['CP']
  ladder_id = ENV['L']
  comment = ENV['C']
  comment = comment.gsub("||", "\n")
  
  current_player = Player.find(current_player_id)
  players = Statistic.find(:all, :conditions => "ladder_id = #{ladder_id}", :include => [:player])
  
  puts current_player.first_name
  puts comment

  players.each do |p|
  	UserMailer.deliver_new_comment(current_player, p.player, ladder, comment)
  	puts "delivered email to #{p.player.email}"
	end
    
end
  

