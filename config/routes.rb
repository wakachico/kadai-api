Rails.application.routes.draw do
  resources :ideas, only: [:index, :create]
end
