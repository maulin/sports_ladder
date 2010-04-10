require 'pp'

desc "cancels challenges that have not been played for 10 days"

task :cancel_outstanding_challenge => :environment do
  oc = Challenge.find(:all, :conditions => "challenge_end_date > str_to_date('#{DateTime.now.strftime('%m%d%y')}', '%m%d%y')")
  
  oc.each do |c|
    chal_stat = Statistic.find(:first, :conditions => "player_id = #{c.challenger_id} and ladder_id = #{c.ladder_id}")
    def_stat = Statistic.find(:first, :conditions => "player_id = #{c.defender_id} and ladder_id = #{c.ladder_id}")
    Statistic.update(chal_stat.id, {:is_challenged => 0, :is_penalized => 1, :penalized_date => DateTime.now + 5.days})
    Statistic.update(def_stat.id, {:is_challenged => 0, :is_penalized => 1, :penalized_date => DateTime.now + 5.days})
    Challenge.delete(c.id)
  end

end

task :remove_penalty => :environment do
  pplayer = Statistic.find(:all, :conditions => "penalized_date > str_to_date('#{DateTime.now.strftime('%m%d%y')}', '%m%d%y')")
  
  pplayer.each do |p|
    p.is_penalized = 0
    p.penalized_date = nil
    p.save
  end
end
