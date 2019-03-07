Rails.application.routes.draw do
  post '/slack' => 'slack_coordinator#receive'

  resources :users, only: [:index, :show]

  resources :games, only: [:new, :create]

  resources :rooms, only: [:index, :create]

  get '' => 'home#index'
end
