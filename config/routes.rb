Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

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

  # ヘルスチェック用
  get '/health', to: 'application#index'
end
