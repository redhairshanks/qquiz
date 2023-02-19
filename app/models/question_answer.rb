class QuestionAnswer < ApplicationRecord

  belongs_to :poll_question
  validates :placement_index, numericality: { only_integer: true }



end