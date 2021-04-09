Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'about' => 'homes#about'
  resources :users, only: [:show, :edit, :update, :destroy]
  resources :documents, except: [:index]
  resources :goals, except: [:index]
  get 'documents' => 'documents#new'
  get 'goals' => 'goals#new'


end
