class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update, :profile]

  # GET /api/v1/users/:id
  def show
    render json: UserSerializer.new(@user).as_json
  end

  # GET /api/v1/users/:id/profile
  def profile
    render json: {
      user: UserSerializer.new(@user).as_json,
      favorites_count: @user.favorites.count,
      notifications_count: @user.notifications.unread.count
    }
  end

  # PATCH/PUT /api/v1/users/:id
  def update
    if @user.update(user_update_params)
      render json: {
        message: 'プロフィールを更新しました',
        user: UserSerializer.new(@user).as_json
      }
    else
      render json: {
        message: 'プロフィールの更新に失敗しました',
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_update_params
    params.require(:user).permit(
      :last_name, :first_name, :last_name_kana, :first_name_kana,
      :nickname, :birth_date
    )
  end
end