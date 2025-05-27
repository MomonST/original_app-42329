class RegionSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :mountains_count, :flowers_count

  def mountains_count
    object.mountains_count
  end

  def flowers_count
    object.flowers_count
  end
end