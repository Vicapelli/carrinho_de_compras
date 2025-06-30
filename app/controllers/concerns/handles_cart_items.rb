module HandlesCartItems
  extend ActiveSupport::Concern

  private

  def add_or_update_cart_item(product_id, quantity)
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    cart_item = @cart.cart_items.find_or_initialize_by(product: product)
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
end