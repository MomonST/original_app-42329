# == Schema Information
#
# Table name: likes
#
#  id              :bigint           not null, primary key
#  user_id         :bigint           not null
#  bloom_report_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Like < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :bloom_report, counter_cache: :likes_count

  # バリデーション
  validates :user_id, uniqueness: { scope: :bloom_report_id, message: "既にいいねしています" }

  # コールバック
  after_create :increment_likes_count
  after_destroy :decrement_likes_count

  private

  def increment_likes_count
    bloom_report.increment!(:likes_count)
  end

  def decrement_likes_count
    bloom_report.decrement!(:likes_count)
  end
end