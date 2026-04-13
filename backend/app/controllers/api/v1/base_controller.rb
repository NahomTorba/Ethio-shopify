module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_seller!

      private

      def current_shop_scope
        current_seller.shops
      end
    end
  end
end
