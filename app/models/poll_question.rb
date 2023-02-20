class PollQuestion < ApplicationRecord

  belongs_to :poll
  validates :points, numericality: { only_integer: true }


  enum type: {
    multiple_choice: "multiple_choice",
    radio: "radio",
    text: "text"
  }

  def create_question(poll, text, type, points, options)
    QuestionAnswer.validate_options(options)
    question = nil
    ActiveRecord::Base.transaction do
      question = Question.create(question_text: text, type: type, points: points, poll: poll)
      options.each_with_index do |option, indx|
        QuestionAnswer.create(poll: poll, poll_question: question, placement_index: indx, answer_text: option[:text], is_answer: option[:is_answer])
      end
    end
    question
  end
end