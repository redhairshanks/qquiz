module PermissionHandler

  def authenticate_user
    if request.headers.present? && request.headers['x-session-id'].present?
      session_data = User.find_by_session(request.headers['x-session-id'])
      @current_user = session_data[:user]
      unless @current_user.present?
        error_handler({user: ["Invalid session, Please login again"]}, :forbidden)
      end
    else
      error_handler({session_id: ["Not found"]}, :forbidden)
    end
  end

  def is_not_permitted?(user_permissions)
    controller_name = self.class.name.to_s.split("::").last.underscore.to_sym
    method_name = self.action_name.to_sym
    if @current_user.present? &&
      Rails.configuration.x.permission.permissions[controller_name].present? &&
      Rails.configuration.x.permission.permissions[controller_name][method_name].present?
      x = Rails.configuration.x.permission.permissions[controller_name][method_name]
      y = user_permissions
      return !(x & y).present?
    end
    true
  end

  def is_valid_organization?
    @current_user.present? &&
      request.headers.present? &&
      request.headers['x-org-id'].present? &&
      request.headers['x-org-id'] == @current_user.organization.id
  end

end