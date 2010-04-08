class AddDescToLadders < ActiveRecord::Migration
  def self.up
		remove_column :ladders, :num_players, :num_challenges
		add_column :ladders, :description, :text, :limit => 500
  end

  def self.down
		remove_column :ladders, :description
  end
end
