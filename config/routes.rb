Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
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
  get 'todo_lists/:id/check' => 'todo_lists#check', as: :check_todo_list
  delete 'todo_lists/delete_finished' => 'todo_lists#delete_finished', as: :delete_finished
  get 'todo_lists/back' => 'todo_lists#back', as: :back_todo_lists
  resources :users, only: [:update]
  resources :documents
  resources :goals
  resources :todo_lists

end
