class Ladder < ActiveRecord::Base
  validates_presence_of :name, :cooldown, :rungs, :best_of
  has_many :statistics
  has_many :comments
  has_many :players, :through => :statistics
  has_many :challenges

  validates_numericality_of :rungs, :greater_than => 0, :only_integer => true
  validates_numericality_of :cooldown, :minimum => 0, :only_integer =>true
  validates_numericality_of :best_of, :greater_than => 0, :less_than => 8, :only_integer => true, :odd => true
  validates_format_of :name, :with => /^[a-z A-Z]+$/, :message => "only aplhabets and spaces are allowed"

	def to_param
	"#{id}-#{name.gsub(/\s/, '-').downcase}"
	end

end
