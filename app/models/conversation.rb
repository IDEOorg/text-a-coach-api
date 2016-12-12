class Conversation < ActiveRecord::Base
  include PgSearch
  include Filterable

  pg_search_scope :search_by_topic,
    :against => [:summary_question, :summary_answer],
    :using => {
      :tsearch => {:prefix => true}
    }

  self.per_page = 100

  acts_as_taggable

  belongs_to :flavor, inverse_of: :conversations
  belongs_to :user, inverse_of: :conversations
  belongs_to :agent, inverse_of: :conversations
  has_many :messages, inverse_of: :conversation, dependent: :destroy

  # Validation rules
  validates :flavor,
    presence: true

  validates :agent,
    presence: true

  validates :user,
    presence: true

  # Scopes used for searching
  scope :flavor_id, -> (flavor_id) { where flavor_id: flavor_id }
  scope :agent_id, -> (agent_id) { where agent_id: agent_id }
  scope :user_id, -> (user_id) { where user_id: user_id }
  scope :tag, -> (tag) { tagged_with tag, any: true }

  def teaser_answer
    self.summary_answer.truncate(120, separator: /\s/)
  end

end
