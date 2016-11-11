class MessageSerializer < ActiveModel::Serializer
  attributes :id, :conversation_id, :direction, :message, :created_at
end
