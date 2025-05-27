class MountainSerializer < ActiveModel::Serializer
  attributes :id, :name, :elevation, :latitude, :longitude, :prefecture, 
             :description, :elevation_category, :flowers_count

  belongs_to :region, serializer: RegionSerializer

  def elevation_category
    object.elevation_category
  end

  def flowers_count
    object.flowers_count
  end
end