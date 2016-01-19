class BattlesController < ApplicationController
  def shipyard
    
  end
  
  def battle
    
  end
  
  def create
    if Battle.between(params[:player_id],params[:enemy_id]).present?
      @conversation = Battle.between(params[:player_id],params[:enemy_id]).first
    else
      @conversation = Battle.create!(conversation_params)
    end

    render json: { battle_id: @conversation.id }
  end

  def show
    @conversation = Battle.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Battle.new
  end

  private
  def conversation_params
    params.permit(:player_id, :enemy_id)
  end

  def interlocutor(conversation)
    current_user == conversation.enemy ? conversation.player : conversation.enemy
  end
end