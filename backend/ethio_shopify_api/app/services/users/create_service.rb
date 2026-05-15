module Shops
  class CreateService
    def self.call(params)
      Shop.create!(params)
    end
  end
end