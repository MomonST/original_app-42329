Rails.application.routes.draw do
  # 既存のルート...
  root "application#index"  # 必要に応じて変更

  # API用のルート追加
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

      # 開花報告関連
      resources :bloom_reports do
        member do
          post :like
          delete :unlike
        end
        collection do
          get :rankings
        end
      end

      # ランキング専用エンドポイント
      get '/rankings/users', to: 'bloom_reports#rankings', defaults: { type: 'users_by_posts' }
      get '/rankings/likes', to: 'bloom_reports#rankings', defaults: { type: 'posts_by_likes' }
      get '/rankings/views', to: 'bloom_reports#rankings', defaults: { type: 'posts_by_views' }
    end
  end
  
  # ヘルスチェック用
  get '/health', to: 'application#index'
  
end