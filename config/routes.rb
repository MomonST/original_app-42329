Rails.application.routes.draw do
  # ルートページ
  root "application#index"

  # API用のルート
  namespace :api do
    namespace :v1 do
      # 認証関連のルート
      post '/auth/register', to: 'auth/registrations#create'
      post '/auth/login', to: 'auth/sessions#create'
      delete '/auth/logout', to: 'auth/sessions#destroy'

      # ユーザー情報
      resources :users, only: [:show, :update] do
        member do
          get :profile
        end
      end

      # 現在のユーザー情報取得用
      get '/me', to: 'users#profile'
    end
  end

  # ヘルスチェック用
  get '/health', to: 'application#index'
end