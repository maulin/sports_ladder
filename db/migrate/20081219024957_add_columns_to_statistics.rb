class AddColumnsToStatistics < ActiveRecord::Migration
  def self.up
		add_column :statistics, :lowest_rank, :integer
		add_column :statistics, :current_rank, :integer
		add_column :statistics, :role, :integer
  end

  def self.down
		remove_column :statistics, :lowest_rank, :current_rank, :role
  end
end
