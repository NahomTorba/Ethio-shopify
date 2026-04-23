class UsersController < ApplicationController
    def index
      users = Users::FetchAllService.call
      render json: users, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
end