require "cgi"

module FrontendUrlBuilder
  module_function

  def base_url
    ENV.fetch("FRONTEND_URL", "http://localhost:3001").chomp("/")
  end

  def shop(username:, mode: nil)
    path = "#{base_url}/shop/#{CGI.escape(username.to_s)}"
    return path if mode.blank?

    "#{path}?mode=#{CGI.escape(mode.to_s)}"
  end

  def setup_shop(user_id:)
    "#{base_url}/setup-shop?user_id=#{CGI.escape(user_id.to_s)}"
  end
end
