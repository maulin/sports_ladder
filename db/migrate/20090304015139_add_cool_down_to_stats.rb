class AddCoolDownToStats < ActiveRecord::Migration
  def self.up
		add_column :statistics, :cooldown_dt, :timestamp
  end

  def self.down
		remove_column :statistics, :cooldown_dt
  end
end
