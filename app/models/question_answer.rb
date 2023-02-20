class QuestionAnswer < ApplicationRecord

  belongs_to :poll_question
  validates :placement_index, numericality: { only_integer: true }

  def self.validate_options(options)
    unless options.is_a? Array
      raise PollException::GeneratedException.new "Options must be a list"
    end

    count_answers = 0
    options.each_with_index do |option, indx|
      unless option[:text].present?
        raise PollException::GeneratedException.new "Options text is compulsory at index:#{indx}"
      end

      unless option[:is_answer].present?
        raise PollException::GeneratedException.new "Option is_answer is compulsory at index:#{indx}"
      end

      unless option[:is_answer] == "true" || option[:is_answer] == "false" || option[:is_answer] == true || option[:is_answer] == false
        raise PollException::GeneratedException.new "Option is_answer is must be true/false at Option:#{indx}"
      end

      if option[:is_answer] == true || option[:is_answer] == "true"
        count_answers += 1
      end
    end

    if count_answers == 0
      raise PollException::GeneratedException.new "At least one option must be an answer"
    end

  end


end