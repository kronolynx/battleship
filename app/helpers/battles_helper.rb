module BattlesHelper

  def enemy(battle)
    current_user == @battle.player ? @battle.enemy : @battle.player
  end
  def enemy_id(battle)
    #battle.player_id == current_user.id ? battle.player_id : battle.player_id
    current_user == @battle.player ? @battle.enemy.id : @battle.player.id
  end

  def player_board(battle)
    @battle.player_id == current_user.id ? @battle.player_board : @battle.enemy_board
  end
end