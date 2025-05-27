# == Schema Information
#
# Table name: bloom_reports
#
#  id             :bigint           not null, primary key
#  user_id        :bigint           not null
#  flower_spot_id :bigint           not null
#  title          :string           not null
#  description    :text
#  bloom_status   :integer          default(0)
#  view_count     :integer          default(0)
#  likes_count    :integer          default(0)
#  status         :integer          default(0)
#  reported_at    :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class BloomReport < ApplicationRecord
  # 列挙型
  enum bloom_status: {
    bud: 0,           # つぼみ
    starting: 1,      # 咲き始め
    peak: 2,          # 見頃
    ending: 3,        # 散り始め
    finished: 4       # 終了
  }

  enum status: {
    pending: 0,       # 審査中
    approved: 1,      # 承認済み
    rejected: 2       # 却下
  }

  # アソシエーション
  belongs_to :user
  belongs_to :flower_spot
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  
  # Active Storage（写真添付）
  has_many_attached :photos

  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :reported_at, presence: true
  validates :photos, presence: true, length: { minimum: 1, maximum: 5 }

  # スコープ
  scope :approved, -> { where(status: :approved) }
  scope :recent, -> { order(reported_at: :desc) }
  scope :popular, -> { order(likes_count: :desc) }
  scope :most_viewed, -> { order(view_count: :desc) }
  scope :by_bloom_status, ->(status) { where(bloom_status: status) }
  scope :this_month, -> { where(reported_at: Time.current.beginning_of_month..Time.current.end_of_month) }

  # コールバック
  after_create :set_reported_at
  before_destroy :decrement_user_posts_count

  # メソッド
  def bloom_status_ja
    case bloom_status
    when 'bud' then 'つぼみ'
    when 'starting' then '咲き始め'
    when 'peak' then '見頃'
    when 'ending' then '散り始め'
    when 'finished' then '終了'
    end
  end

  def status_ja
    case status
    when 'pending' then '審査中'
    when 'approved' then '承認済み'
    when 'rejected' then '却下'
    end
  end

  def liked_by?(user)
    return false unless user
    likes.exists?(user: user)
  end

  def increment_view_count!
    increment!(:view_count)
  end

  def location_name
    "#{flower_spot.mountain.name}（#{flower_spot.mountain.prefecture}）"
  end

  def flower_name
    flower_spot.flower.name
  end

  # ランキング用スコア計算
  def popularity_score
    (likes_count * 3) + (view_count * 0.1) + (Time.current - created_at).to_i / 86400
  end

  private

  def set_reported_at
    self.update_column(:reported_at, Time.current) if reported_at.blank?
  end

  def decrement_user_posts_count
    # ユーザーの投稿数カウンターをデクリメント（後で実装）
  end
end