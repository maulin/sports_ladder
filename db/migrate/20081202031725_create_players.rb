class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :login
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
