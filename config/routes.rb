Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'about' => 'homes#about'
  get 'documents' => 'documents#new'
  get 'goals' => 'goals#new'
  resources :users, only: [:show, :edit, :update, :destroy]
  resources :documents, except: [:index]
  resources :goals, except: [:index]



end
