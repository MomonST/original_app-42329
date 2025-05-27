# == Schema Information
#
# Table name: regions
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  code       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Region < ApplicationRecord
  # バリデーション
  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  # アソシエーション
  has_many :mountains, dependent: :destroy
  # has_many :user_regions, dependent: :destroy
  # has_many :users, through: :user_regions

  # スコープ
  scope :ordered, -> { order(:name) }

  # メソッド
  def mountains_count
    mountains.count
  end

  def flowers_count
    flowers.distinct.count
  end

  def flowers
    Flower.joins(flower_spots: { mountain: :region }).where(regions: { id: id })
  end
end