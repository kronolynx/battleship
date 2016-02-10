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
    @shooting = current_user.id == @battle.active_player
  end


  def edit
    if current_user.id == @battle.active_player
      PrivatePub.publish_to("/user_#{enemy_id @battle}", "activateClick();$('#player-board ##{params[:attack]}').addClass('target');console.log('attack');")
      @battle.active_player = enemy_id @battle
      @battle.save
    else


    end
    @player_board = player_board(@battle)
    respond_to do |format|
      format.js { render :nothing => true }
      #format.js { j render partial: 'edit' }
    end
  end

  def ready
    # set the user board according , if is the user or the enemy
    @battle.player_id == current_user.id ? @battle.player_board = params[:board] : @battle.enemy_board= params[:board]
    @battle.save
    @player_board = player_board(@battle)

    if enemy_board(@battle).nil?
      @waiting = true
      PrivatePub.publish_to("/user_#{enemy_id @battle}", '$("#messages").text("Enemy is ready").removeClass().addClass("bg-info");')
    else
      @waiting = false
      @battle.active_player = enemy_id @battle
      @battle.save
      PrivatePub.publish_to("/user_#{enemy_id @battle}", "activateClick();console.log('ready to attack');")
    end
    # here must go an else in case both are ready we will set the turn to the other player
    respond_to do |format|
      format.js { j render partial: 'ready' }
    end
  end

  def destroy
    if params[:winner]
      @battle.player_board = nil
      @battle.enemy_board = nil
      @battle.active_player = nil
      @battle.save
      @winner = current_user
      @winner.wins = @winner.wins + 1
      @winner.save
    else
      @winner = enemy @battle
      current_user.losses = current_user.losses + 1
      current_user.save
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