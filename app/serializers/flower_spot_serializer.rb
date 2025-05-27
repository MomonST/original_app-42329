class FlowerSpotSerializer < ActiveModel::Serializer
  attributes :id, :best_viewing_time, :notes, :location_name, :bloom_status

  belongs_to :flower, serializer: FlowerSerializer
  belongs_to :mountain, serializer: MountainSerializer

  def location_name
    object.location_name
  end

  def bloom_status
    object.bloom_status
  end
end