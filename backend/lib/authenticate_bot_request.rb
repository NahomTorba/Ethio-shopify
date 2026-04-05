class AuthenticateBotRequest
  PROTECTED_PATHS = [
    %r{\A/api/v1(/|\z)},
    %r{\A/bot(/|\z)}
  ].freeze

  EXCLUDED_PATHS = [
    /setup-shop/,
    /\/shop\//,
    /\/shops\/setup/,
    /\/shops\/\d+\/products/,
    /\/products\z/
  ].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    path = request.path
    
    # Check if excluded
    is_excluded = EXCLUDED_PATHS.any? { |p| p.match?(path) }
    return @app.call(env) if is_excluded
    
    # Check if protected
    is_protected = PROTECTED_PATHS.any? { |p| p.match?(path) }
    return @app.call(env) unless is_protected
    
    # Authenticate
    token = bearer_token(request)
    return unauthorized unless token

    payload = JsonWebToken.decode(token)
    user = User.find_by(id: payload["sub"])
    return unauthorized unless user

    Current.user = user
    env["current_user"] = user
    env["jwt.payload"] = payload

    @app.call(env)
  rescue => e
    Rails.logger.error "Auth error: #{e.message}"
    unauthorized
  ensure
    Current.reset
  end

  private

  def bearer_token(request)
    header = request.get_header("HTTP_AUTHORIZATION").to_s
    scheme, token = header.split(" ", 2)
    token if scheme == "Bearer" && token.present?
  end

  def unauthorized
    [401, { "Content-Type" => "application/json" }, [{ error: "Unauthorized" }.to_json]]
  end
end
