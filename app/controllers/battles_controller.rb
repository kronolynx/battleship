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
  end

  def edit
    @battle = Battle.find(params[:id])
    @player_board = @battle.player_id == current_user.id ? @battle.player_board : @battle.enemy_board

    PrivatePub.publish_to("/user_#{enemy_id @battle}", "$('#player-board #pos#{params[:attack]}').addClass('target');" )

    respond_to do |format|
      format.html { render :nothing => true }
      #format.html { redirect_to battle_path(@battle) }
      format.js { render :nothing => true }
    end
  end
end