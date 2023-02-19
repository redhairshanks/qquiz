class PollQuestion < ApplicationRecord

  belongs_to :poll
  validates :points, numericality: { only_integer: true }


  enum type: {
    single_choice: "single_choice",
    multiple_choice: "multiple_choice",
    radio: "radio",
    text: "text"
  }



end