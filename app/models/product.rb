class Product < ApplicationRecord
  belongs_to :category
  has_many :ratings
  has_many :order_details

  scope :get_all_products, -> do
    joins("INNER JOIN categories ON products.category_id = categories.id")
    .select("products.*, categories.name as category_name")
  end
end
