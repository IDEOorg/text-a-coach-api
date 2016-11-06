class Platform < ActiveRecord::Base
  has_many :conversations, inverse_of: :platform, dependent: :destroy

  # Validation rules
  validates :name,
    presence: true
end
