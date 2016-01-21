class MessagesController < ApplicationController
  
  def create
    @battle = Battle.find(message_params[:battle_id])
    @message = @battle.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!
  end
  def message_params
    params.require(:message).permit(:body, :battle_id)
  end

end