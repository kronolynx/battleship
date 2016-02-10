class BattlesController < ApplicationController
  include BattlesHelper
  before_action :get_battle, except: [:create]

  def create
    Rails.logger.debug params.inspect
    if Battle.between(params[:player_id], params[:enemy_id]).present?
      @battle = Battle.between(params[:player_id], params[:enemy_id]).first

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
    @enemy = enemy(@battle)
    @player_board = player_board(@battle)
  end


  def edit
    @player_board = player_board(@battle)

    PrivatePub.publish_to("/user_#{enemy_id @battle}", "$('#player-board ##{params[:attack]}').addClass('target');")

    respond_to do |format|
      #format.html { render :nothing => true }
      #format.html { redirect_to battle_path(@battle) }
      format.js { render :nothing => true }
    end
  end

  def ready
    # set the user board according , if is the user or the enemy
    @battle.player_id == current_user.id ? @battle.player_board = params[:board] : @battle.enemy_board= params[:board]
    @battle.save
    @player_board = player_board(@battle)
    # todo if the other enemy board is not null then do something else tell the other player that this player is waiting

    respond_to do |format|
      format.js { j render partial: 'ready' }
    end
  end

  def destroy
    if params[:winner]
      @battle.player_board = nil
      @battle.enemy_board = nil
      @battle.save
      @winner = current_user
    else
      @winner = enemy @battle
      PrivatePub.publish_to("/user_#{enemy_id @battle}",  "$.post('#{finish_path(@battle)}',{winner: true});");
    end

    respond_to do |format|
      format.js { j render partial: 'destroy' }
    end
  end

  private
  def get_battle
    @battle = Battle.find(params[:id])
  end
end