class AddAvatarToUser < ActiveRecord::Migration
  def self.up
    add_column :players, :avatar_file_name, :string
    add_column :players, :avatar_content_type, :string
    add_column :players, :avatar_file_size, :integer
  end

  def self.down
    remove_column :players, :avatar_file_name
    remove_column :players, :avatar_content_type
    remove_column :players, :avatar_file_size
  end
end
