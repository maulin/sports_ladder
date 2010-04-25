class AddChallengePenaltyLimitsToLadder < ActiveRecord::Migration
  def self.up
    add_column :ladders, :challenge_time_limit, :integer
    add_column :ladders, :penalty_time_limit, :integer
  end

  def self.down
    remove_column :ladders, :challenge_time_limit
    remove_column :ladders, :penalty_time_limit
  end
end
