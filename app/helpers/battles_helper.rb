module BattlesHelper

  def enemy
    current_user == @battle.player ? @battle.enemy : @battle.player
  end
  def enemy_id
    current_user == @battle.player ? @battle.enemy.id : @battle.player.id
  end

  def player_board
    @battle.player_id == current_user.id ? @battle.player_board : @battle.enemy_board
  end
  def enemy_board
    @battle.player_id == current_user.id ?  @battle.enemy_board : @battle.player_board
  end

  def hit?(attack)
    enemy_board = @enemy_board

    if 'acegikmoqs'.include? enemy_board[attack.to_i]
      hit = true
    else
      hit = false
    end
    enemy_board[attack.to_i,1] = enemy_board[attack.to_i].next
    if current_user.id == @battle.player.id
      @battle.enemy_board = enemy_board
      @battle.save
    else
      @battle.player_board = enemy_board
      @battle.save
    end
    hit
  end

  def game_over?
    is_over = true
    for i in 0..99
      ship_char = @enemy_board[i]
      if ship_char != 'y' && ship_char != 'z' &&  ('acegikmoqs'.include? ship_char)
        is_over = false
        break
      end
    end
    is_over
  end
end