class Product < ApplicationRecord
  belongs_to :category
  has_many :ratings
  has_many :order_details

  mount_uploader :image, ImageUploader

  ATTRIBUTE_PARAMS = %i(name category_id price quantity image type description)

  validates :name, presence: true, length: {maximum: Settings.product.max_name_length}
  validates :category_id, presence: true
  validates :price, presence: true, numericality: {only_float: true}
  validates :quantity, presence: true, numericality: {only_integer: true}

  def product_info base_url
    {
      id: self.id,
      name: self.name,
      price: self.price,
      quantity: self.quantity,
      category_id: self.category_id,
      image: {url: "#{base_url}#{self.image.url}"},
      type: self.type,
      description: self.description,
      category_name: Category.get_category_name(self.category_id),
    }
  end
end
