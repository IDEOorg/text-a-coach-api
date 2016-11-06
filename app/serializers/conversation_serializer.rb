class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :agent_id, :user_id, :summary_question, :summary_answer, :last_message_at

  belongs_to :agent
  belongs_to :user
end
