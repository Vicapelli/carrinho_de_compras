class CartsController < ApplicationController
  before_action :set_cart

  def show
    render json: cart_response
  end

  def add_item
    render json: { error: 'Cart not found' }, status: :not_found and return unless @cart

    add_or_update_cart_item(item_params[:product_id], item_params[:quantity])
    render json: cart_response, status: :ok
  end

  def create
    unless @cart
      @cart = Cart.create!
      session[:cart_id] = @cart.id
    end

    add_or_update_cart_item(item_params[:product_id], item_params[:quantity])
    render json: cart_response, status: :ok
  end

  def remove_product
    render json: { error: "Cart not found" }, status: :not_found and return unless @cart

    cart_item = @cart.cart_items.find_by(product_id: item_params[:product_id])
    render json: { error: 'Product not listed in cart' }, status: :not_found and return unless cart_item

    cart_item.destroy
    render json: cart_response, status: :ok
  end

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id] || item_params[:id])
  end

  def add_or_update_cart_item(product_id, quantity)
    quantity = params[:quantity].to_i
    cart_item = @cart.cart_items.find_or_initialize_by(product_id: product_id)
    cart_item.quantity ||= 0
    cart_item.quantity += quantity
    cart_item.save!
    cart_item
  end

  def cart_response
    {
      id: @cart.id,
      products: @cart.cart_items.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price.to_f,
          total_price: (item.product.price * item.quantity).to_f
        }
      end,
      total_price: @cart.total_price.to_f
    }
  end

  def item_params
    params.permit(:id, :product_id, :quantity)
  end
end
