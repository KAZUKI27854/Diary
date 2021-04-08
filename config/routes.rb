Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  resources :users, only: [:show, :edit, :update, :destroy]
  resources :documents
  resources :goals, except: [:index]
  get 'goals' => 'goals#new'

end
