class PollParticipant < ApplicationRecord

  belongs_to :poll
  belongs_to :user

  validates :final_score, numericality: { only_integer: true }

end