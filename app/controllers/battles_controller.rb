class BattlesController < ApplicationController
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
    redirect_to battle_path(@battle)
  end
  
  def show
    @battle = Battle.find(params[:id])
    @enemy = (current_user == @battle.player ? @battle.enemy : @battle.player)
  end
end