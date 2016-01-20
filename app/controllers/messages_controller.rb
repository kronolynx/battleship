class MessagesController < ApplicationController
  
  def create
    @battle = Battle.find(params[:conversation_id])
    @message = @battle.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!

    @path = battle_path(@conversation)
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
  

end