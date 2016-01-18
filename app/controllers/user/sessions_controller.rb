class User::SessionsController < Devise::SessionsController
  def create
    super
    current_user.online = 2
    current_user.save
  end
  
  def destroy
    current_user.online = 0
    current_user.save
    super
  end
end