Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_scope :user do
    post 'users/guest_sign_in' => 'users/sessions#guest_sign_in'
  end

  namespace :todo_lists do
    resources :searches, only: [:index]
  end

  namespace :documents do
    resources :searches, only: [:index]
  end

  root to: 'homes#top'
  get 'tutorial' => 'homes#tutorial'
  get 'policy' => 'homes#policy', as: :policy

  get 'users' => 'users#show', as: :my_page
  patch 'users/withdraw' => 'users#withdraw', as: :withdraw_user
  resources :users, only: [:update]

  #エラーメッセージ発生後にリロードするとエラーになるため指定
  get 'documents/:id' => 'documents#edit'
  resources :documents, only: [:create, :edit, :update, :destroy]

  resources :goals, only: [:create, :update, :destroy]

  get 'todo_lists/back' => 'todo_lists#back', as: :back_todo_lists
  get 'todo_lists/:id/check' => 'todo_lists#check', as: :check_todo_list
  delete 'todo_lists/delete_finished' => 'todo_lists#delete_finished', as: :delete_finished
  resources :todo_lists, except: [:new, :show]
end