class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: 'Record not found' }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
