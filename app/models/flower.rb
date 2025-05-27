# == Schema Information
#
# Table name: flowers
#
#  id                :bigint           not null, primary key
#  name              :string           not null
#  scientific_name   :string
#  description       :text
#  color             :string
#  size              :string
#  habitat           :string
#  bloom_start_month :integer          not null
#  bloom_end_month   :integer          not null
#  peak_month        :integer
#  altitude_min      :integer
#  altitude_max      :integer
#  difficulty_level  :integer          default(0)
#  image_url         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Flower < ApplicationRecord
  # 列挙型
  enum difficulty_level: {
    beginner: 0,      # 初級
    intermediate: 1,  # 中級
    advanced: 2       # 上級
  }

  # バリデーション
  validates :name, presence: true
  validates :bloom_start_month, presence: true, inclusion: { in: 1..12 }
  validates :bloom_end_month, presence: true, inclusion: { in: 1..12 }
  validates :peak_month, inclusion: { in: 1..12 }, allow_nil: true
  validates :altitude_min, numericality: { greater_than: 0 }, allow_nil: true
  validates :altitude_max, numericality: { greater_than: 0 }, allow_nil: true

  # アソシエーション
  has_many :flower_spots, dependent: :destroy
  has_many :mountains, through: :flower_spots
  # has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites

  # スコープ
  scope :blooming_in_month, ->(month) { where('bloom_start_month <= ? AND bloom_end_month >= ?', month, month) }
  scope :by_difficulty, ->(level) { where(difficulty_level: level) }
  scope :by_altitude_range, ->(min, max) { where('altitude_min >= ? AND altitude_max <= ?', min, max) }

  # メソッド
  def blooming_months
    if bloom_start_month <= bloom_end_month
      (bloom_start_month..bloom_end_month).to_a
    else
      # 年をまたぐ場合（例：11月〜3月）
      (bloom_start_month..12).to_a + (1..bloom_end_month).to_a
    end
  end

  def is_blooming_now?
    current_month = Date.current.month
    blooming_months.include?(current_month)
  end

  def days_until_bloom
    return 0 if is_blooming_now?
    
    current_date = Date.current
    current_year = current_date.year
    
    # 今年の開花開始日を計算
    bloom_start_date = Date.new(current_year, bloom_start_month, 1)
    
    # 既に今年の開花期間が過ぎている場合は来年
    if current_date > Date.new(current_year, bloom_end_month, -1)
      bloom_start_date = Date.new(current_year + 1, bloom_start_month, 1)
    end
    
    (bloom_start_date - current_date).to_i
  end

  def difficulty_level_ja
    case difficulty_level
    when 'beginner'
      '初級'
    when 'intermediate'
      '中級'
    when 'advanced'
      '上級'
    end
  end
end