Rails.application.routes.draw do
 
  #ログイン・ログアウト用のルーティング
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  root 'transactions#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :transactions do
    member do #1件のデータに対する操作
      patch :mark_as_paid
    end
    collection do #データ全体に対する操作
      get :unpaid
      get :export
    end
  end

end
