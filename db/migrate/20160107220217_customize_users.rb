class CustomizeUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, null: false,  default: "", unique: true
    add_column :users, :wins, :integer, default: 0
    add_column :users, :losses, :integer, default: 0
    add_column :users, :online, :integer, default: 0
  end
end
