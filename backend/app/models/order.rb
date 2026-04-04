class Order < ApplicationRecord
  belongs_to :shop

  validates :status, presence: true, allow_blank: false
end
