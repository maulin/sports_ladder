class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.integer :player_id
      t.integer :ladder_id
      t.integer :highest_rank

      t.timestamps
    end
  end

  def self.down
    drop_table :statistics
  end
end
