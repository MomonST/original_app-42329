class BloomReportSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :bloom_status, :bloom_status_ja,
             :view_count, :likes_count, :status, :status_ja, :reported_at,
             :location_name, :flower_name, :created_at

  belongs_to :user, serializer: UserSerializer
  belongs_to :flower_spot, serializer: FlowerSpotSerializer

  def initialize(object, options = {})
    super
    @include_photos = options[:include_photos]
  end

  def attributes(*args)
    data = super
    data[:photos] = photo_urls if @include_photos
    data[:is_liked] = is_liked if current_user
    data
  end

  private

  def photo_urls
    object.photos.map do |photo|
      {
        id: photo.id,
        url: Rails.application.routes.url_helpers.rails_blob_url(photo, only_path: true),
        thumbnail_url: Rails.application.routes.url_helpers.rails_representation_url(
          photo.variant(resize_to_limit: [300, 300]), only_path: true
        )
      }
    end
  end

  def is_liked
    return false unless current_user
    object.liked_by?(current_user)
  end

  def current_user
    # コンテキストから現在のユーザーを取得
    instance_options[:current_user]
  end
end