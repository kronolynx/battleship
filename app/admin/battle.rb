ActiveAdmin.register Battle do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :id, :player_id , :enemy_id, :player_board, :enemy_board, :active_player

  index do
    column :id
    column 'Player' do |m|
      User.find(m.player_id).username
    end
    column 'Enemy' do |m|
      User.find(m.enemy_id).username
    end
    column :player_board
    column :enemy_board
    column :active_player
    actions
  end
  config.filters = false
  
end
