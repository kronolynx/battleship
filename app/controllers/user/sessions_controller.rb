class User::SessionsController < Devise::SessionsController
  def create
    super
    current_user.online = "online"
    current_user.save
  end
  
  def destroy
    current_user.online = "offline"
    current_user.save
    super
  end
end