class User::SessionsController < Devise::SessionsController
  after_filter :log_failed_login, :only => :new
  
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
  
  private
    def log_failed_login
      MyLog.info("#{request.filtered_parameters["user"]["email"]} failed to login from #{request.remote_ip}") if failed_login?
    end
    
    def failed_login?
      (options = env["warden.options"]) && options[:action] == "unauthenticated"
    end
end