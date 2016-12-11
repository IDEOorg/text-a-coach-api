class Flavor < ActiveRecord::Base
  has_many :conversations, inverse_of: :flavor, dependent: :destroy

  # Validation rules
  validates :name,
    presence: true
end
