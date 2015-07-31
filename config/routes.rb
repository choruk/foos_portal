Rails.application.routes.draw do
  post '/slack' => 'slack_coordinator#receive'

  resources :users, only: [:index, :show]

  get '' => 'home#index'
end
