# == Schema Information
#
# Table name: mountains
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  elevation   :integer
#  latitude    :decimal(10, 6)
#  longitude   :decimal(10, 6)
#  region_id   :bigint           not null
#  prefecture  :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Mountain < ApplicationRecord
  # アソシエーション
  belongs_to :region
  has_many :flower_spots, dependent: :destroy
  has_many :flowers, through: :flower_spots

  # バリデーション
  validates :name, presence: true
  validates :latitude, :longitude, presence: true
  validates :elevation, numericality: { greater_than: 0 }, allow_nil: true
  validates :prefecture, presence: true

  # スコープ
  scope :by_region, ->(region_id) { where(region_id: region_id) }
  scope :by_prefecture, ->(prefecture) { where(prefecture: prefecture) }
  scope :by_elevation_range, ->(min, max) { where(elevation: min..max) }

  # メソッド
  def elevation_category
    return '低山' if elevation.nil? || elevation < 1000
    return '中山' if elevation < 2000
    return '高山' if elevation < 3000
    '超高山'
  end

  def flowers_blooming_in_month(month)
    flowers.where('bloom_start_month <= ? AND bloom_end_month >= ?', month, month)
  end

  def flowers_count
    flowers.count
  end
end