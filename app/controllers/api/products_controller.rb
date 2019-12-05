class Api::ProductsController < ApplicationController
  def index
    products = Product.all.page(params[:page])
    total_pages = products.total_pages
    list_products = []
    products.each do |p|
      list_products << p.product_info(request.base_url)
    end

    render json: {status: :ok, products: list_products, total_pages: total_pages}
  end

  def new
    product = Product.new
    categories = Category.all

    render json: {status: :ok, product: product, categories: categories}
  end

  def create
    product = Product.new product_params
    if product.save
      render json: {status: :ok, message: "Success", product: product}
    else
      render json: {status: :not_found, message: "Fail"}
    end
  end

  def show
    categories = Category.all
    product = Product.find_by(id: params[:id])
    if product.nil?
      render json: {status: :not_found, message: "Not found"}
    else
      render json: {status: :ok, product: product.product_info(request.base_url), categories: categories}
    end
  end

  def update
    categories = Category.all
    product = Product.find_by(id: params[:id])
    return render json: {status: :not_found, message: "Fail"} if product.nil?

    if product.update product_params
      render json: {status: :ok, message: "Update successful",product: product.product_info(request.base_url), categories: categories}
    else
      errors = product.errors.messages.values
      render json: {status: :bad_request, message: "Fail", errors: errors, categories: categories}
    end
  end

  def destroy
    product = Product.find_by id: params[:id]
    product.destroy unless product.nil?

    products = Product.all.page(params[:page])
    total_pages = products.total_pages
    list_products = []
    products.each do |p|
      list_products << p.product_info(request.base_url)
    end

    message = "Success"
    render json: {status: :ok, message: message, products: list_products, total_pages: total_pages}
  end

  private

  def product_params
    params.require(:product).permit Product::ATTRIBUTE_PARAMS
  end
end
