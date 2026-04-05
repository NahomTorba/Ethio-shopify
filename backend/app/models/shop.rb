class Shop < ApplicationRecord
  belongs_to :user, optional: true
  has_many :categories, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :products, dependent: :destroy

  validates :username, uniqueness: true, allow_nil: true
end
