class Api::V1::BaseController < ApplicationController
  # CSRF保護を無効化（API用）
  skip_before_action :verify_authenticity_token
  
  # JSON形式でレスポンス
  respond_to :json

  private

  # JWT認証
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    return render json: { error: '認証が必要です' }, status: :unauthorized unless token

    @current_user = User.decode_jwt(token)
    return render json: { error: '無効なトークンです' }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end
