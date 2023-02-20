class QuestionController < ApplicationController

  def create_question
    if params[:poll_id].present? && params[:text].present? &&
      params[:type].present? && params[:points].present? &&
      params[:options].present?
      poll = Poll.find_by(id: params[:poll_id])
      if poll.present?
        question = PollQuestion.create_question(poll, params[:text], params[:type], params[:points], params[:options])
        if question.present? && question.errors.blank?
          success_handler({question: question}, nil)
        else
          error_handler({question: question.errors}, nil)
        end
      else
        error_handler({poll: ["Poll not found"]}, :bad_request)
      end
    else
      error_handler({poll: ["Missing parameters"]}, :bad_request)
    end
  end

  def answer_question
    if params[:poll_id].present? && params[:question_id].present? && params[:option_id_list].present?
      poll = Poll.find_by(id: params[:poll_id])
      if poll.present?
        question = PollQuestion.find_by(poll: poll, id: params[:question_id])
        if question.present?
          user_answers = UserAnswer.create_user_answer(question, params[:option_id_list])
          if user_answers.present? && user_answers.errors.blank?
            success_handler({answer: user_answers}, nil)
          else
            error_handler({answer: user_answers.errors.messages}, :bad_request)
          end
        else
          error_handler({question: ["Not found"]}, :bad_request)
        end
      else
        error_handler({poll: ["Poll not found"]}, :bad_request)
      end
    else
      error_handler({answer: ["Missing parameters"]}, :bad_request)
    end
  end



end