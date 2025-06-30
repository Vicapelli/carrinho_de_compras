class CartsController < ApplicationController
  include HandlesCartItems
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
    product = Product.find(item_params[:product_id])
    cart_item = @cart.cart_items.find_by(product: product)
    render json: { error: 'Product not listed in cart' }, status: :not_found and return unless cart_item

    cart_item.destroy
    render json: { response: 'Product removed' }, status: :ok
  end

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id] || item_params[:id])
  end

  def item_params
    params.permit(:id, :product_id, :quantity)
  end
end
