class MessagesController < ApplicationController

  def create
    @battle = Battle.find(message_params[:battle_id])
    @message = @battle.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!

    #PrivatePub.publish_to battle_path(@battle, "aler('test'")
    @path = battle_path(@battle)
  end
  def message_params
    params.require(:message).permit(:body, :battle_id)
  end

end
