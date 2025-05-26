class Api::V1::Auth::SessionsController < Api::V1::BaseController
  def create
    user = User.find_by(email: params[:user][:email])
    
    if user&.valid_password?(params[:user][:password])
      token = user.generate_jwt
      render json: {
        message: 'ログインしました',
        user: UserSerializer.new(user).as_json,
        token: token
      }, status: :ok
    else
      render json: {
        message: 'メールアドレスまたはパスワードが間違っています'
      }, status: :unauthorized
    end
  end

  def destroy
    render json: {
      message: 'ログアウトしました'
    }, status: :ok
  end
end