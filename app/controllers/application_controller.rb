class ApplicationController < ActionController::Base
  before_action :basic_auth, if: -> { Rails.env.production? }

  # CSRF保護（通常のWebアプリ用）
  protect_from_forgery with: :exception
  
  # Basic認証（既存設定があれば維持）
  # http_basic_authenticate_with name: "your_name", password: "your_password" if Rails.env.production?

  # 簡単なindexアクション（ルートページ用）
  def index
    render json: { 
      message: "Mountain Flower API", 
      version: "1.0.0",
      status: "running" 
    }
  end
  

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]  # 環境変数を読み込む記述に変更
    end
  end

  # 現在のユーザー取得（Web用）
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def require_login
    redirect_to login_path unless current_user
  end

end
