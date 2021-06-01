Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    post 'users/guest_sign_in' => 'users/sessions#guest_sign_in'
  end

  namespace :todo_lists do
    resources :searches, only: :index, defaults: { format: :json }
  end

  root to: 'homes#top'
  get 'about' => 'homes#about'
  get 'goals' => 'goals#new'
  get 'users' => 'users#show', as: :my_page
  patch 'users/withdraw' => 'users#withdraw', as: :withdraw_user
  resources :users, only: [:update]
  resources :documents
  resources :goals
  resources :todo_lists

end
