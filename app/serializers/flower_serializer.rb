class FlowerSerializer < ActiveModel::Serializer
  attributes :id, :name, :scientific_name, :description, :color, :size, :habitat,
             :bloom_start_month, :bloom_end_month, :peak_month,
             :altitude_min, :altitude_max, :difficulty_level, :difficulty_level_ja,
             :image_url, :is_blooming_now, :days_until_bloom, :blooming_months

  def difficulty_level_ja
    object.difficulty_level_ja
  end

  def is_blooming_now
    object.is_blooming_now?
  end

  def days_until_bloom
    object.days_until_bloom
  end

  def blooming_months
    object.blooming_months
  end
end