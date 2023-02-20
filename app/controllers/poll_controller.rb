class PollController < ApplicationController

  # Excepted request body format
  before_action :authenticate_user

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
        poll_participant.final_score = 0
        poll_participant.save
        if poll_participant.present? && poll_participant.errors.blank?
          success_handler({poll_participant: {poll_id: poll_participant[:poll_id],
                                              user_id: poll_participant[:user_id],
                                              start_time: poll_participant[:start_time]}}, nil)
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
          poll_participant.final_score = calculate_poll_score(poll)
          poll_participant.end_time = DateTime.now
          poll_participant.save
          if poll_participant.present? && poll_participant.errors.blank?
            success_handler({poll_participant: poll_participant}, nil)
          else
            error_handler({poll_participant: poll_participant.errors.messages}, :bad_request)
          end
        else
          error_handler({poll_participant: ["You have not started the poll"]}, :bad_request)
        end
      else
        error_handler({poll: ["Not found"]}, :bad_request)
      end
    else
      error_handler({poll: ["poll_id not found"]}, :bad_request)
    end
  end

  def fetch_poll_participants
    result = []
    if params[:poll_id].present?
      poll = Poll.find_by(id: params[:poll_id])
      if poll.present?
        poll_participants = PollParticipant.where(poll: poll)
        if poll_participants.present?

          poll_participants.each do |participant|
            result.push({
                          poll: participant.poll.name,
                          user: participant.user.name,
                          start_time: participant.start_time,
                          end_time: participant.end_time,
                          final_score: participant.final_score
                        })
          end
          success_handler({poll_participants: result}, nil)
        else
          success_handler({poll_participants: []}, nil)
        end
      else
        error_handler({poll: ["Not found"]}, :bad_request)
      end
    else
      error_handler({poll: ["poll_id not found"]}, :bad_request)
    end
  end

  def show_poll
    if params[:poll_id].present?
      result = {
        poll: nil,
        questions: nil
      }
      poll = Poll.find_by(id: params[:poll_id])
      if poll.present?
        # TODO: Change following
        result[:poll] = poll
        result[:questions] = poll.get_all_questions
        success_handler({poll: result}, nil)
      else
        error_handler({poll: ["Not found"]}, :bad_request)
      end
    else
      error_handler({poll: ["poll_id not found"]}, :bad_request)
    end
  end

  def share_poll
    if params[:poll_id].present?
      poll = Poll.find_by(id: params[:poll_id])
      if poll.present?
        url_suffix = SecureRandom.hex(10)
        share_link = "#{Rails.configuration.x.app_config.host[:root]}/poll/link/#{url_suffix}"
        url = "poll/#{params[:poll_id]}"
        Utils.cache(url_suffix, url, 7.days)
        success_handler({url: share_link}, nil)
      else
        error_handler({poll: ["Not found"]}, :bad_request)
      end
    else
      error_handler({poll: ["poll_id not found"]}, :bad_request)
    end
  end

  def get_poll
    if params[:id].present?
      cached_url = Utils.cache_read(params[:id])
      if cached_url.present?
        success_handler({url: "#{Rails.configuration.x.app_config.host[:root]}/#{cached_url}"}, nil)
      else
        error_handler({link: ["link not found"]}, :bad_request)
      end
    else
      error_handler({link: ["link not found"]}, :bad_request)
    end
  end

  private

  def calculate_poll_score(poll)
    score = 0
    poll_ques = PollQuestion.select(:id).where(poll: poll)
    ques_ids = poll_ques.map{|ques| ques.id}
    user_ans = UserAnswer.select(:score).where(poll_question_id: ques_ids, user: @current_user)
    if user_ans.present?
      ques_score = user_ans.map{|ans| ans[:score]}
      score = ques_score.sum
    end
    score
  end

end