class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :city, :state
end
