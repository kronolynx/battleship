class BattlesController < ApplicationController
  def create
    if Battle.between(params[:player_id],params[:enemy_id]).present?
      @battle = Battle.between(params[:player_id],params[:enemy_id]).first
    else
      @battle = Battle.new
      @battle.player_id = params[:player_id]
      @battle.enemy_id = params[:enemy_id]
      @battle.save!
    end
    @enemy = (current_user == @battle.player ? @battle.enemy : @battle.player)
  end
  
  def attack
    
  end
  
end