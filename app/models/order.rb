class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy

  enum status: {Approved: 1, Pending: 0}

  def order_info
    {
      id: self.id,
      user_id: self.user_id,
      total_money: self.total_money,
      status: self.status,
      address: self.address,
      phone: self.phone,
      description: self.description,
      user_name: User.get_user_name(self.user_id),
    }
  end
end
