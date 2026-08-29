Rails.application.routes.draw do
 
  devise_for :users
  root 'homes#top'
  get 'homes/about', to: 'homes#about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show, :edit, :update]
  resources :books, only: [:create, :index, :show, :destroy, :edit, :update]
  
end
