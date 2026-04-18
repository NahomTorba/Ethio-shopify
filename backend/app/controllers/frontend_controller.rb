class FrontendController < ActionController::Base
  def serve
    path = params[:path]
    Rails.logger.info("FrontendController called with path: #{path.inspect}")
    path = "index.html" if path.blank?

    file_path = Rails.root.join("public", "frontend", path)
    Rails.logger.info("Looking for file: #{file_path}")
    Rails.logger.info("File exists: #{File.exist?(file_path)}")

    if File.exist?(file_path) && !File.directory?(file_path)
      ext = File.extname(file_path)
      content_type = case ext
      when ".js" then "application/javascript; charset=utf-8"
      when ".css" then "text/css; charset=utf-8"
      when ".json" then "application/json; charset=utf-8"
      when ".ico" then "image/x-icon"
      when ".png" then "image/png"
      when ".svg" then "image/svg+xml"
      else "text/html; charset=utf-8"
      end

      send_file file_path, type: content_type, disposition: "inline"
    else
      render file: Rails.root.join("public", "frontend", "index.html"), content_type: "text/html; charset=utf-8"
    end
  end
end
