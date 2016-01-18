class ChangeColumnUserOnline < ActiveRecord::Migration
  def change
    change_column :users, :online,  :string, default: "offline"
  end
end
