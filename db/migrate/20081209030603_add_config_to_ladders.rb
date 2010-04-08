class AddConfigToLadders < ActiveRecord::Migration
  def self.up
    add_column :ladders, :sport, :text
		add_column :ladders, :best_of, :integer
		add_column :ladders, :cooldown, :integer
		add_column :ladders, :rungs, :integer
		
  end

  def self.down
    remove_column :ladders, :sport
		remove_column :ladders, :best_of
		remove_column :ladders, :cooldown
		remove_column :ladders, :rungs
  end
end
