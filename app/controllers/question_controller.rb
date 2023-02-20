class QuestionController < ApplicationController

  before_action :authenticate_user

  def create_question
    if params[:poll_id].present? && params[:text].present? &&
      params[:points].present? && params[:options].present?
      poll = Poll.find_by(id: params[:poll_id])
      if poll.present?
        result = PollQuestion.create_question(poll, params[:text], params[:points], params[:options])
        if result.present? && result[:question].present? && result[:question].errors.blank?
          success_handler({question: result}, nil)
        else
          error_handler({question: result[:question].errors.messages}, nil)
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
          if is_poll_started(poll)
            user_answers = UserAnswer.create_user_answer(question, params[:option_id_list], @current_user)
            if user_answers.present? && user_answers.errors.blank?
              success_handler({answer: user_answers}, nil)
            else
              error_handler({answer: user_answers.errors.messages}, :bad_request)
            end
          else
            error_handler({poll: ["Either poll not started OR poll has ended"]}, :bad_request)
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

  private

  def is_poll_started(poll)
    result = false
    poll_participant = PollParticipant.find_by(poll: poll, user: @current_user)
    if poll_participant.present? && poll_participant.start_time.present? && poll_participant.end_time.blank?
      result = true
    end
    result
  end

end