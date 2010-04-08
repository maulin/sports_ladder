class AddChallengeEndDate < ActiveRecord::Migration
  def self.up
    add_column :challenges, :challenge_end_date, :timestamp
  end

  def self.down
    remove_column :challenges, :challenge_end_date
  end
end
