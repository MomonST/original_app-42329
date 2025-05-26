class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # バリデーション
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name_kana, presence: true, length: { maximum: 50 }
  validates :first_name_kana, presence: true, length: { maximum: 50 }
  validates :nickname, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :birth_date, presence: true

  # アソシエーション
  # has_many :notifications, dependent: :destroy
  # has_many :favorites, dependent: :destroy
  # has_many :favorite_flowers, through: :favorites, source: :flower
  # has_many :user_regions, dependent: :destroy
  # has_many :regions, through: :user_regions

  # スコープ
  # scope :active, -> { where(deleted_at: nil) }

  # メソッド
  def full_name
    "#{last_name} #{first_name}"
  end

  def full_name_kana
    "#{last_name_kana} #{first_name_kana}"
  end

  # def age
    #return nil unless birth_date
    
    # today = Date.current
    #age = today.year - birth_date.year
    #age -= 1 if today < birth_date + age.years
    #age
  #end

  # JWT生成
  def generate_jwt
    JWT.encode(
      {
        user_id: id,
        email: email,
        nickname: nickname,
        exp: 7.days.from_now.to_i
      },
      Rails.application.credentials.secret_key_base
    )
  end

  # JWT検証
  def self.decode_jwt(token)
    decoded = JWT.decode(
      token,
      Rails.application.credentials.secret_key_base
    ).first
    
    find(decoded['user_id'])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil
  end
end
