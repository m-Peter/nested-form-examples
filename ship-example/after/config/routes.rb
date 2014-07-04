Rails.application.routes.draw do
  resources :ships

  root 'ships#index'
end
