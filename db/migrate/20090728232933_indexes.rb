class Indexes < ActiveRecord::Migration
  def self.up
		add_index :challenges, :defender_id
		add_index :challenges, :challenger_id
		add_index :challenges, :ladder_id
		add_index :challenges, :winner_id

		add_index :comments, :player_id
		add_index :comments, :ladder_id

		add_index :statistics, :player_id
		add_index :statistics, :ladder_id
		add_index :statistics, :last_chal_player_id
  end

  def self.down
		remove_index :challenges, :defender_id
		remove_index :challenges, :challenger_id
		remove_index :challenges, :ladder_id
		remove_index :challenges, :winner_id

		remove_index :comments, :player_id
		remove_index :comments, :ladder_id

		remove_index :statistics, :player_id
		remove_index :statistics, :ladder_id
		remove_index :statistics, :last_chal_player_id
  end
end
