class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.integer :player_id
      t.integer :enemy_id
      t.string :player_board
      t.string :enemy_board
      t.integer :active_player

      t.timestamps null: false
    end
    
    add_index :battles, :player_id
    add_index :battles, :enemy_id
  end
end
