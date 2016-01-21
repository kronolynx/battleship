Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user/registrations", :sessions => "user/sessions"}
  root 'welcome#index'

  resources :messages

  get 'users', to: "users#index"
  get 'user/:id', to: 'users#show', as: 'user'
  post 'battlefield', to: 'battles#create'
  get 'battle/:id', to: 'battles#show', as: 'battle'
  
end
