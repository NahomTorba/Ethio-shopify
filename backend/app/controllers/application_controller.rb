class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def current_seller
    @current_seller ||= Current.user || request.env["current_user"] || seller_from_bearer_token
  end

  def authenticate_seller!
    return if current_seller.present?

    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def seller_from_bearer_token
    header = request.get_header("HTTP_AUTHORIZATION").to_s
    scheme, token = header.split(" ", 2)
    return if scheme != "Bearer" || token.blank?

    payload = JsonWebToken.decode(token)
    User.find_by(id: payload["sub"])
  rescue JsonWebToken::DecodeError
    nil
  end
end
