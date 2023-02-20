class Poll < ApplicationRecord

  belongs_to :user
  has_many :poll_questions
  validates :time_limit_in_seconds, numericality: { only_integer: true }

  def get_all_questions
    questions = []
    poll_ques = self.poll_questions
    if poll_ques.present?
      poll_ques.each do |ques|
        poll_opts = ques.question_answers.select(:id, :poll_question_id, :answer_text, :placement_index)
        questions.push({
                         question: ques[:question_text],
                         options: poll_opts
                       })
      end
    else
      raise PollException::GeneratedException.new "Poll has no questions"
    end
    questions
  end
end