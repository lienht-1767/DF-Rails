class Category < ApplicationRecord
  has_many :products

  scope :get_category_name, ->(id){where(id: id).pluck(:name).first}
end
