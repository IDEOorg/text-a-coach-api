class Message < ActiveRecord::Base
  belongs_to :conversation, inverse_of: :messages

  # Field rules
  enum direction: {
    direction_in:  1,
    direction_out: 2
  }

  # Validation rules
  validates :direction,
    presence: true,
    inclusion: {
      in: directions.keys.to_a,
      message: "%{value} is not a valid option"
    }

  validates :message,
    presence: true

end
