Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user/registrations", :sessions => "user/sessions"}
  root 'welcome#index'
  get '/users', to: "users#index"
  get '/user/:id', to: 'users#show', as: 'user'
end
