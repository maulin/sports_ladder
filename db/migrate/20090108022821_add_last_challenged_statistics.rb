class AddLastChallengedStatistics < ActiveRecord::Migration
  def self.up
    add_column :statistics, :last_chal_player_id, :integer
  end

  def self.down
    remove_column :statistics, :last_chal_player_id
  end
end
