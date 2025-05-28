class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :nickname, :full_name, :full_name_kana, :created_at

  def full_name
    object.full_name
  end

  def full_name_kana
    object.full_name_kana
  end
end