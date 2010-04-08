class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
			t.integer :player_id
			t.integer :ladder_id
			t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
