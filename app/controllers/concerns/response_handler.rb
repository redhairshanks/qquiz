module ResponseHandler

  extend ActiveSupport::Concern

  def error_handler(object, status = :unprocessable_entity)
    render(
      json: {
        message: Rack::Utils::HTTP_STATUS_CODES[400],
        data: nil,
        errors: object
      },
      status: status
    )
  end

  def success_handler(object, serializer, view = :base, status = :ok, paginate = false)
    serialized_object = serializer.present? ? (serializer.render_as_hash object, view: view) : object
    json_obj = {
      message: Rack::Utils::HTTP_STATUS_CODES[200],
      data: serialized_object,
      errors: nil
    }
    if paginate.present?
      json_obj[:paginate] = {
        limit: @limit,
        offset: @offset
      }
    end
    render(
      json: json_obj,
      status: status
    )
  end
end