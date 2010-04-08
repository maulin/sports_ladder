class IsPenalized < ActiveRecord::Migration
  def self.up
    add_column :statistics, :is_penalized, :integer
  end

  def self.down
    remove_column :statistics, :is_penalized
  end
end
