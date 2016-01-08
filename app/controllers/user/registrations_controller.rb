class User::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:username, :avatar)
    devise_parameter_sanitizer.for(:account_update).push(:username, :avatar)
  end
end