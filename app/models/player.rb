require 'digest/sha1'

class Player < ActiveRecord::Base
  has_many :statistics
  has_many :comments
  has_many :ladders, :through => :statistics
  has_many :challenges, :class_name => 'Challenge', :foreign_key => 'challenger_id'
  has_many :defences, :class_name => 'Challenge', :foreign_key => 'defender_id'

  #paperclip
  has_attached_file :avatar, :default_url => '/system/avatars/default_:style_avatar.jpg',
                    :styles => { :large => "120x120>", :medium => "48x48>", :thumb => "26x26>" }
  
  validates_presence_of :first_name, :last_name, :login, :email
  validates_presence_of :password, :if => :validate_password?
  validates_uniqueness_of :login, :email
  validates_format_of :first_name, :last_name, :with => /^[a-z A-Z]+$/, :message => "only aplhabets and spaces are allowed"
  validates_format_of :login, :with => /^[a-z A-Z0-9]+$/, :message => "only aplhanumerics and spaces are allowed"
  validates_length_of :login, :in => 6..15
  validates_format_of :password, :with => /^[a-z A-Z0-9]+$/, 
											:message => "only aplhanumerics and spaces are allowed", :if => :validate_password?
  validates_length_of :password, :in => 6..15, :if => :validate_password?

  before_save :hash_password

  attr_accessor :updated_password, :m, :matches, :w, :matches_won, :l, :matches_lost, :stat,
                :c, :tot_challenges, :cw, :challenges_won, :d, :tot_defences, :dw, :defences_won
  

  def validate_password?
    updated_password || new_record?
  end

  def hash_password
    if validate_password?
      self.password = Digest::SHA1.hexdigest(self.password)
    end
  end
  
  def Player.find_ladders(player)
    unless player.nil?
      s = Statistic.find(:all, :select => :ladder_id, :conditions => {:player_id => player.id})
      Ladder.find(s.collect!{|x| x.ladder_id})
    else
      nil
    end
  end

  def player_profile(ladder_id)

    @stat = Statistic.find(:first, :conditions => "player_id = #{self.id} and ladder_id = #{ladder_id}")
    
    @m = Challenge.find(:all, :conditions => "ladder_id = #{ladder_id} and (challenger_id = #{self.id} or defender_id = #{self.id}) and winner_id is not null")
    @matches = @m.size

    @w = Challenge.find(:all, :conditions => "ladder_id = #{ladder_id} and winner_id = #{self.id}", :include => [:challenger, :defender], 
    :order => "updated_at DESC")
    @l = Challenge.find(:all, :conditions => "ladder_id = #{ladder_id} and (challenger_id = #{self.id} or defender_id = #{self.id}) and winner_id != #{self.id}",
    :include => [:challenger, :defender], :order => "updated_at DESC")      

    @matches_won = @w.size
    @matches_lost = @l.size

    @c = Challenge.find(:all, :conditions => "ladder_id = #{ladder_id} and challenger_id = #{self.id} and winner_id is not null")
    @tot_challenges = @c.size

    @cw = Challenge.find(:all, :conditions => "ladder_id = #{ladder_id} and challenger_id = #{self.id} and winner_id = #{self.id}")
    @challenges_won = @cw.size

    @d = Challenge.find(:all, :conditions => "ladder_id = #{ladder_id} and defender_id = #{self.id} and winner_id is not null")
    @tot_defences = @d.size

    @dw = Challenge.find(:all, :conditions => "ladder_id = #{ladder_id} and defender_id = #{self.id} and winner_id = #{self.id}")
    @defences_won = @dw.size
    
	end	

end
