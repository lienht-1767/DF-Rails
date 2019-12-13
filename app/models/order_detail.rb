class OrderDetail < ApplicationRecord
  has_one :product
  has_one :order

  delegate :price, to: :product, prefix: true, allow_nil: true

  scope :get_detail_orders, ->(order_id){where order_id: order_id}
  scope :get_total_money, ->(order_id){OrderDetail.get_detail_orders(order_id).pluck(:price, :quantity)}

  def detail_order_info
    {
      id: self.id,
      order_id: self.order_id,
      product_id: self.product_id,
      quantity: self.quantity,
      price: Product.get_product_price(self.product_id),
      product_name: Product.get_product_name(self.product_id),
      total: Product.get_product_price(self.product_id) * self.quantity
    }
  end
end
