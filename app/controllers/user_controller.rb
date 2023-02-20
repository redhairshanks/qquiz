class UserController < ApplicationController

  def create_user
    if params[:name].present? && params[:email].present? && params[:password].present?
      is_user = User.find_by(email: params[:email])
      if is_user.present?
        error_handler({email: ["Email already in use"]}, :bad_request)
      else
        user = User.create(name: params[:name], email: params[:email], password: params[:password])
        if user.present? && user.errors.blank?
          success_handler({user: {name: user[:name], email: user[:email]}}, nil)
        else
          error_handler({user: user.errors.messages}, :bad_request)
        end
      end
    else
      error_handler({user: ["Name/Email/Password not found"]}, :bad_request)
    end
  end

  def sign_in_user
    if params[:email].present? && params[:password].present?
      if Utils::StringUtility.is_email?(params[:email])
        user = User.find_by(email: params[:email])
        if user.present?
          if user.authenticate(params[:password])
            success_handler({user_id: user.id, session_id: User.create_session(user)}, nil)
          else
            error_handler({password: ["Incorrect password"]}, :forbidden)
          end
        else
          error_handler({user: ["Not found"]}, :bad_request)
        end
      else
        error_handler({email: ["Invalid email"]})
      end
    else
      error_handler({user: ["Email/Password not found"]}, :bad_request)
    end
  end
end