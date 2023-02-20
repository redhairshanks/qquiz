class PollQuestion < ApplicationRecord

  belongs_to :poll
  validates :points, numericality: { only_integer: true }
  has_many :question_answers


  def self.create_question(poll, text, points, ans_options)
    QuestionAnswer.validate_options(ans_options)
    result = {
      question: nil,
      options: []
    }
    ActiveRecord::Base.transaction do
      question = PollQuestion.create(question_text: text, points: points, poll: poll)
      result[:question] = question
      ans_options.each_with_index do |option, indx|
        qa = QuestionAnswer.create(poll_question: question, placement_index: indx, answer_text: option[:text], is_answer: option[:is_answer])
        result[:options].push(qa)
      end
    end
    result
  end
end