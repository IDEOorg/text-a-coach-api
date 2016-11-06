class Agent < ActiveRecord::Base
  has_many :conversations, inverse_of: :agent, dependent: :destroy

  # All lower case emails
  before_validation(on: :create) do
    self.email.try :downcase!
  end

  # Validation rules
  validates :name,
    presence: true

  validates :job_title,
    presence: true

  validates :email,
    presence: true

end
