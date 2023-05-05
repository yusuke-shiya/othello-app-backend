Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  namespace :api do
    namespace :v1 do
      resources :messages, only: [:index]
      resources :battle_rooms, only: [:create]
    end
  end
end
