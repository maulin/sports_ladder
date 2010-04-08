class AddIsChallengedToStatistics < ActiveRecord::Migration
  def self.up
    add_column :statistics, :is_challenged, :integer
  end

  def self.down
    remove_column :statistics, :is_challenged
  end
end
