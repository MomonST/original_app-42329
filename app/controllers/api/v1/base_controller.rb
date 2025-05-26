class Api::V1::BaseController < ApplicationController
  # CSRF保護を無効化（API用）
  skip_before_action :verify_authenticity_token
  
  # JSON形式でレスポンス
  respond_to :json

  # Basic認証をスキップ（API用）
  skip_before_action :authenticate_user!, raise: false if respond_to?(:authenticate_user!)

  private

  # JWT認証
  def authenticate_user!
    token = extract_token_from_header
    return render_unauthorized('認証が必要です') unless token

    @current_user = User.decode_jwt(token)
    return render_unauthorized('無効なトークンです') unless @current_user
  end

  def current_user
    @current_user
  end

  def extract_token_from_header
    auth_header = request.headers['Authorization']
    return nil unless auth_header&.start_with?('Bearer ')
    
    auth_header.split(' ').last
  end

  def render_unauthorized(message)
    render json: { error: message }, status: :unauthorized
  end
end
