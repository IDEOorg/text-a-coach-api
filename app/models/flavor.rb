class Flavor < ActiveRecord::Base
  has_many :conversations, inverse_of: :flavor, dependent: :destroy

  # Validation rules
  validates :name,
    presence: true

  validates :handle, #used for ENV variable names
    presence: true

  # letters-only all caps
  validates_format_of :handle,
	  with: /\A[A-Z0-9_]+\z/,
	  message: "All caps letters with numbers and underscores"
end
