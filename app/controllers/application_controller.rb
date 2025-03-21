class ApplicationController < ActionController::API
  before_action :authorize_request
  
  attr_reader :current_user

  private
  # def authorize_request
  #   header = request.headers['Authorization']
  #   token = header.split(' ').last if header

  #   if token && BlacklistedToken.exists?(token: token)
  #     render json: { error: 'Invalid or expired token' }, status: :unauthorized
  #     return
  #   end

  #   decoded = JsonWebToken.decode(token)
  #   if decoded
  #     @current_user = User.find(decoded[:user_id])
  #   else
  #     render json: { error: 'Unauthorized' }, status: :unauthorized
  #   end
  # end

  # def authorize_request
  #   header = request.headers['Authorization']
  #   token = header.split(' ').last if header
  #   begin
  #     decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
  #     @current_user = User.find(decoded['user_id'])
  #   rescue ActiveRecord::RecordNotFound
  #     render json: { error: 'User not found' }, status: :unauthorized
  #   rescue JWT::DecodeError
  #     render json: { error: 'Invalid token' }, status: :unauthorized
  #   end
  # end

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?
  
    if token.nil?
      return render json: { error: 'Token is required' }, status: :unauthorized
    end
  
    if BlacklistedToken.exists?(token: token)
      return render json: { error: 'Invalid or expired token' }, status: :unauthorized
    end
  
    # decoded = JsonWebToken.decode(token)
    if decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
     @current_user = User.find(decoded['user_id'])
    #  decoded.present? && decoded[:user_id]
    #   @current_user = User.find_by(id: decoded[:user_id])
    else
      render json: { error: 'Unauthorized or User ID required' }, status: :unauthorized
    end
  end
  
  
end
