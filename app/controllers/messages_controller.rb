class MessagesController < ApplicationController

  def create
    @battle = Battle.find(message_params[:battle_id])
    @message = @battle.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!

    #PrivatePub.publish_to(battle_path(@battle), "alert('hi from the battle')")
    #PrivatePub.publish_to(users_path, "alert('hi from the controller')")
    @path = battle_path(@battle)
  end
  def message_params
    params.require(:message).permit(:body, :battle_id)
  end

end
