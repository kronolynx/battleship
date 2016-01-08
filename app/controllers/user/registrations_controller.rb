class User::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:username, :photo)
    devise_parameter_sanitizer.for(:account_update).push(:username, :photo)
  end
end