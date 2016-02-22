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
  csv do
    column :id
    column :player_id
    column :enemy_id
    column :player_board
    column :enemy_board
    column :active_player
  end


  collection_action :import, :method=>:get do
    MyLog.info("Inside import get")
    # render the view
  end
  collection_action :import, :method=>:post do
    MyLog.info("Inside import post")
    # read the csv and for each line create a new battle
  end

  #TODO fix the links
  action_item do
    link_to "Import battle", import_admin_battles_path #'app/views/admin/battles/import.html.haml'
  end

  # not sure yet if this will be needed
  #controller do
  #  def import
   #   if request.post?
   #     MyLog.info("Inside import post")
   #     redirect admin_battles_path
    #  else
    #    render partial: 'import'
    #    MyLog.info("Inside import get")
   #   end
   # end
  #end
  config.filters = false


end
