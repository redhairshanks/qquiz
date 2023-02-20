class UserController < ApplicationController
  def sign_in_user
    if params[:email].present? && params[:password].present?
      if Utils::StringUtility.is_email?(params[:email])
        user = User.find_by(email: params[:email])
        if user.present?
          if user.authentication(params[:password])
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