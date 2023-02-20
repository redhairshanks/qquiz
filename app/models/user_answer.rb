class UserAnswer < ApplicationRecord

  belongs_to :user
  belongs_to :poll_question
  validates :score, numericality: { only_integer: true }

  def self.create_user_answer(question, submitted_options, user)
    score = 0
    question_ans = QuestionAnswer.where(poll_question: question, is_answer: true)
    if question_ans.present?
      answer_ids = question_ans.map{|ans| ans.id}
      if answer_ids.sort == submitted_options.sort
        score = question[:points]
      end
      UserAnswer.create(user: user, poll_question: question, answers: {submitted: submitted_options}, score: score)
    else
      raise PollException::GeneratedException.new "Question has no answers"
    end
  end

end