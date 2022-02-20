Rails.application.routes.draw do
  root "mazes#index"
  
  resources :mazes

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end