class Api::Admin::OrdersController < Api::Admin::BaseAdminController
  def index
    orders = Order.all.page(params[:page])
    total_pages = orders.total_pages
    list_orders = []
    orders.each do |o|
      o.total_money = 0
      details = OrderDetail.get_detail_orders(o.id)
      details.map{|d| o.total_money += d.detail_order_info[:total]}
      list_orders << o.order_info
    end

    render json: {status: :ok, orders: list_orders, total_pages: total_pages}
  end

  def show
    details = OrderDetail.get_detail_orders(params[:id])
    list_orders = []
    details.each do |o|
      list_orders << o.detail_order_info
    end

    if details.nil?
      render json: {status: :not_found, message: "Not found"}
    else
      render json: {status: :ok, detail_orders: list_orders}
    end
  end

  def destroy
    order = Order.find_by id: params[:id]
    order.destroy unless order.nil?

    orders = Order.all.page(params[:page])
    total_pages = orders.total_pages
    list_orders = []
    orders.each do |o|
      o.total_money = 0
      details = OrderDetail.get_detail_orders(o.id)
      details.map{|d| o.total_money += d.detail_order_info[:total]}
      list_orders << o.order_info
    end

    render json: {status: :ok, orders: list_orders, total_pages: total_pages}
  end

  def update
    order = Order.find_by id: params[:id]
    return render json: {status: :not_found, message: "Fail"} if order.nil?

    if order.update status: params[:status]
      orders = Order.all.page(params[:page])
      total_pages = orders.total_pages
      list_orders = []
      orders.each do |o|
        o.total_money = 0
        details = OrderDetail.get_detail_orders(o.id)
        details.map{|d| o.total_money += d.detail_order_info[:total]}
        list_orders << o.order_info
      end

      render json: {status: :ok, orders: list_orders, total_pages: total_pages}
    else
      orders = Order.all.page(params[:page])
      total_pages = orders.total_pages
      list_orders = []
      orders.each do |o|
        o.total_money = 0
        details = OrderDetail.get_detail_orders(o.id)
        details.map{|d| o.total_money += d.detail_order_info[:total]}
        list_orders << o.order_info
      end
      errors = order.errors.messages.values
      render json: {status: :bad_request, message: "Fail", errors: errors, orders: list_orders, total_pages: total_pages}
    end
  end
end
