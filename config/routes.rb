Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :messages, only: [:index]
      resources :battle_rooms, only: [:create]
    end
  end
end
