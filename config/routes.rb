Rails.application.routes.draw do
  get 'notifications/index'
  root "monsters#index"
  
  resources :users, only: [:new, :create]
  
  resources :monsters, only: [:index, :show, :new, :create]
  
  resources :tracked_monsters, only: [:index, :create, :destroy] do
    member do
      patch :reset_timer
      delete :lost_track
    end
  end
  
  # Notification endpoint
  get 'notifications', to: 'notifications#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
