Rails.application.routes.draw do
  # 🆕 API用のルート追加
  namespace :api do
    namespace :v1 do
      # 認証関連
      devise_for :users, controllers: {
        registrations: 'api/v1/auth/registrations',
        sessions: 'api/v1/auth/sessions'
      }

      # ユーザー情報
      resources :users, only: [:show, :update] do
        member do
          get :profile
        end
      end
    end
  end
  
  # 既存のルート...
  root "application#index"  # 必要に応じて変更
end
