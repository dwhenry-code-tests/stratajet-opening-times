Rails.application.routes.draw do
  resources :opening_times, only: :index

  resource :importers, only: [:new, :create]

  root 'opening_times#index'
end
