module BattlesHelper

  def enemy()
    current_user == @battle.player ? @battle.enemy : @battle.player
  end
  def enemy_id()
    #battle.player_id == current_user.id ? battle.player_id : battle.player_id
    current_user == @battle.player ? @battle.enemy.id : @battle.player.id
  end

  def player_board()
    @battle.player_id == current_user.id ? @battle.player_board : @battle.enemy_board
  end
  def enemy_board()
    @battle.player_id == current_user.id ?  @battle.enemy_board : @battle.player_board
  end

  def hit?(attack)
    enemyBoard = enemy_board

    MyLog.info("enemyBoard #{enemyBoard}")

    if 'acegikmoqs'.include? enemyBoard[attack.to_i]
      enemyBoard[attack.to_i,1] = enemyBoard[attack.to_i].next
      MyLog.info("enemyBoard #{enemyBoard}")
      if current_user.id == @battle.player.id
        @battle.enemy_board = enemyBoard
        @battle.save
        MyLog.info("enemyBoare #{@battle.enemy_board}")
      else
        @battle.player_board = enemyBoard
        @battle.save
        MyLog.info("enemyBoarp #{@battle.player_board}")
      end

      @hit = true
    else
      @hit = false
    end

  end
end