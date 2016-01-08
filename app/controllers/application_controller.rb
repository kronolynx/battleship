class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?

  def current_user
    # we save the user in a varial to avoid searching constantly in the database
    # if the user has already been found return the variable if not search assign to the variable
    # then return it
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    # with the !! we convert anything in to a boolean
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform this action"
      redirect_to root_path
    end
  end
end
