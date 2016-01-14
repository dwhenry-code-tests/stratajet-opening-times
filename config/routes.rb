Rails.application.routes.draw do
  resource :importers, only: [:new, :create]

  #root 'opening_times#index'
  root 'importers#new'
end
