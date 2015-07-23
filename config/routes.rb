Rails.application.routes.draw do
  post '/slack' => 'slack_coordinator#receive'
end
