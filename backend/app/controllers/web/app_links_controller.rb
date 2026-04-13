module Web
  class AppLinksController < ActionController::API
    def shop
      redirect_to FrontendUrlBuilder.shop(username: params[:username], mode: params[:mode]), allow_other_host: true
    end

    def setup_shop
      redirect_to FrontendUrlBuilder.setup_shop(user_id: params[:user_id]), allow_other_host: true
    end
  end
end
