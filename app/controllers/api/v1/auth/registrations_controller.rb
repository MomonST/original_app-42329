class Api::V1::Auth::RegistrationsController < Api::V1::BaseController
  def create
    user = User.new(user_params)
    
    if user.save
      token = user.generate_jwt
      render json: {
        message: 'ユーザー登録が完了しました',
        user: UserSerializer.new(user).as_json,
        token: token
      }, status: :created
    else
      render json: {
        message: 'ユーザー登録に失敗しました',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation,
      :last_name, :first_name, :last_name_kana, :first_name_kana,
      :nickname, :birth_date
    )
  end
end