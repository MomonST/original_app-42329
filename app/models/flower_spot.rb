# == Schema Information
#
# Table name: flower_spots
#
#  id                 :bigint           not null, primary key
#  flower_id          :bigint           not null
#  mountain_id        :bigint           not null
#  best_viewing_time  :string
#  notes              :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class FlowerSpot < ApplicationRecord
  # アソシエーション
  belongs_to :flower
  belongs_to :mountain
  has_many :bloom_reports, dependent: :destroy

  # バリデーション
  validates :flower_id, uniqueness: { scope: :mountain_id, message: "この山には既に同じ花が登録されています" }

  # スコープ
  scope :by_month, ->(month) { joins(:flower).where('flowers.bloom_start_month <= ? AND flowers.bloom_end_month >= ?', month, month) }
  scope :by_region, ->(region_id) { joins(:mountain).where(mountains: { region_id: region_id }) }

  # メソッド
  def location_name
    "#{mountain.name}（#{mountain.prefecture}）"
  end

  def bloom_status
    if flower.is_blooming_now?
      '開花中'
    elsif flower.days_until_bloom > 0
      "あと#{flower.days_until_bloom}日"
    else
      '開花終了'
    end
  end

  # 最新の開花状況取得
  def latest_bloom_status
    bloom_reports.approved.recent.first&.bloom_status
  end

  def latest_bloom_report
    bloom_reports.approved.recent.first
  end

  def reports_count
    bloom_reports.approved.count
  end
end