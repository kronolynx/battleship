class CustomizeUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, unique: true
    add_column :users, :picture, :string
    add_column :users, :wins, :integer, default: 0
    add_column :users, :losses, :integer, default: 0
    add_column :users, :online, :boolean, default: false
  end
end
