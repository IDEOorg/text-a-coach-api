class Conversation < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_topic, :against => [:summary_question, :summary_answer, :tag_list]

  self.per_page = 100

  acts_as_taggable

  belongs_to :platform, inverse_of: :conversations
  belongs_to :user, inverse_of: :conversations
  belongs_to :agent, inverse_of: :conversations
  has_many :messages, inverse_of: :conversation, dependent: :destroy

  # Validation rules
  validates :platform,
    presence: true

  validates :agent,
    presence: true

  validates :user,
    presence: true
end
