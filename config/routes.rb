Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    post 'users/guest_sign_in' => 'users/sessions#guest_sign_in'
  end

  root to: 'homes#top'
  get 'about' => 'homes#about'
  get 'goals' => 'goals#new'
  get 'users' => 'users#show', as: :my_page
  resources :users, only: [:update, :destroy]
  resources :documents
  resources :goals

end
