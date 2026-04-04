module Webhooks
  class ChapaController < ApplicationController
    def verify
      head :ok
    end
  end
end
