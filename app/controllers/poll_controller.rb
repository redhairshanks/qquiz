class PollController < ApplicationController

  # Excepted request body format

  def create_poll
    if params[:name].present?
      time_limit = params[:time_limit_in_seconds].present? ? params[:time_limit_in_seconds] : -1
      poll = Poll.create(name: params[:name], time_limit_in_seconds: time_limit, user: @current_user)
      if poll.present? && poll.errors.blank?
        success_handler({poll: poll}, nil)
      else
        error_handler({poll: poll.errors.messages}, :bad_request)
      end
    else
      error_handler({name: ["Poll name not found"]}, :bad_request)
    end
  end

  def start_poll
    if params[:poll_id].present?
      poll = Poll.find_by(id: params[:poll_id])
      if poll.present?
        poll_participant = PollParticipant.find_or_initialize_by(user: @current_user, poll: poll)
        poll_participant.start_time = DateTime.now
        poll_participant.save
        if poll_participant.present? && poll_participant.errors.blank?
          success_handler({poll_participant: poll_participant}, nil)
        else
          error_handler({poll_participant: poll_participant.errors.messages}, :bad_request)
        end
      else
        error_handler({poll: ["Not found"]}, :bad_request)
      end
    else
      error_handler({poll: ["poll_id not found"]}, :bad_request)
    end
  end


  def end_poll
    if params[:poll_id].present?
      poll = Poll.find_by(id: params[:poll_id])
      if poll.present?
        poll_participant = PollParticipant.find_by(user: @current_user, poll: poll)
        if poll_participant.present?
          poll_participant.end_time = DateTime.now
          poll_participant.save
          if poll_participant.present? && poll_participant.errors.blank?
            # TODO: Calculate the score of participant
            success_handler({poll_participant: poll_participant}, nil)
          else
            error_handler({poll_participant: poll_participant.errors.messages}, :bad_request)
          end
        else
          error_handler({poll_participant: ["You have not started the quiz"]}, :bad_request)
        end
      else
        error_handler({poll: ["Not found"]}, :bad_request)
      end
    else
      error_handler({poll: ["poll_id not found"]}, :bad_request)
    end
  end


  def share_poll
  #   create short url with poll_id
  end

end