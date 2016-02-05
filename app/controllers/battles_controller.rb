class BattlesController < ApplicationController
  include BattlesHelper
  def create
    Rails.logger.debug params.inspect
    if Battle.between(params[:player_id],params[:enemy_id]).present?
      @battle = Battle.between(params[:player_id],params[:enemy_id]).first

    else
      @battle = Battle.new
      @battle.player_id = params[:player_id]
      @battle.enemy_id = params[:enemy_id]
      @battle.save!
    end
    # when a player starts a battle redirects the enemy to the battle page
    PrivatePub.publish_to("/user_#{enemy_id @battle}", "window.location.href = \"#{battle_path(@battle)}\";")
    PrivatePub.publish_to("/users", "console.log('this should be in a new file and render a partial user list');")
    # redirect player to the battle
    redirect_to battle_path(@battle)

  end
  
  def show
    @battle = Battle.find(params[:id])
    @enemy = enemy(@battle)
    @player_board = player_board(@battle)
  end


  def edit
    @battle = Battle.find(params[:id])
    @player_board = player_board(@battle)

    PrivatePub.publish_to("/user_#{enemy_id @battle}", "$('#player-board ##{params[:attack]}').addClass('target');" )

    respond_to do |format|
      format.html { render :nothing => true }
      #format.html { redirect_to battle_path(@battle) }
      format.js { render :nothing => true }
    end
  end

  def ready
    @battle = Battle.find(params[:id])
    # set the user board according , if is the user or the enemy
    @battle.player_id == current_user.id ? @battle.player_board = params[:board] : @battle.enemy_board= params[:board]
    @battle.save
    @player_board = player_board(@battle)
    # todo if the other enemy board is not null then do something else tell the other player that this player is waiting

    respond_to do |format|
      format.html { render :nothing => true }
      #format.html { redirect_to battle_path(@battle) }
      format.js { render 'battles/set_board' }
    end
  end
end