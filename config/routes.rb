Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user/registrations"}
  root 'welcome#index'
  get '/users', to: "users#index"
  get '/user/:id', to: 'users#show', as: 'user'
end
