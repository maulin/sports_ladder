class CreateChallenges < ActiveRecord::Migration
  def self.up
    create_table :challenges do |t|
      t.integer :challenger_id
      t.integer :challenged_id
      t.string :score

      t.timestamps
    end
  end

  def self.down
    drop_table :challenges
  end
end
