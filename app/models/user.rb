class User < ActiveRecord::Base
  has_many :conversations, inverse_of: :user, dependent: :destroy

  # All lower case emails
  before_validation(on: :create) do
    self.email.try :downcase!
  end

  # Validation rules
  validates :phone_number,
    presence: true

  validates :name,
    presence: true
end
