class UserAnswer < ApplicationRecord

  belongs_to :user
  belongs_to :poll_question
  validates :score, numericality: { only_integer: true }
end