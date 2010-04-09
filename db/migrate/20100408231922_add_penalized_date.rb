class AddPenalizedDate < ActiveRecord::Migration
  def self.up
    add_column :statistics, :penalized_date, :timestamp
  end

  def self.down
    remove_column :statistics, :penalized_date
  end
end
