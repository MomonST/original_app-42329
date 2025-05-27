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
  has_many :bloom_reports, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_bloom_reports, through: :likes, source: :bloom_report

  # スコープ
  scope :active, -> { where(deleted_at: nil) }

  # メソッド
  def full_name
    "#{last_name} #{first_name}"
  end

  def full_name_kana
    "#{last_name_kana} #{first_name_kana}"
  end

  def age
    return nil unless birth_date
    today = Date.current
    age = today.year - birth_date.year
    age -= 1 if today < birth_date + age.years
    age
  end

  # ユーザーランキング用メソッド
  def posts_count
    bloom_reports.approved.count
  end

  def total_likes_received
    bloom_reports.approved.sum(:likes_count)
  end

  def total_views_received
    bloom_reports.approved.sum(:view_count)
  end

  def ranking_score
    (posts_count * 10) + (total_likes_received * 5) + (total_views_received * 0.1)
  end

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
