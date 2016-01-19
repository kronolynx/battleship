class User::SessionsController < Devise::SessionsController
  def create
    super
    current_user.online = "online"
    current_user.save
    # log to file succesful logins 
    MyLog.info("#{current_user.email} logged successfully from #{current_user.current_sign_in_ip}")
    
  end
  
  def destroy
    current_user.online = "offline"
    current_user.save
    super
  end
end