class WelcomeController < ApplicationController
  def index
    @users = User.all.order(online: :desc)
  end
end