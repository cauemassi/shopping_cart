class CartsController < ApplicationController
  include ActionController::Cookies

  before_action :set_cart

  def create

  end

  def show
  end

  def add_items
    @cart_item = CartItem.find_by(cart: @cart, product: params[:product_id])

    if @cart_item
      @cart_item.quantity += params[:quantity]

      @cart_item.save!
    else
      render json: "error: Product not in Cart to be add. Please first add Product"
    end
  end

  def delete_items

  end

  private

  def set_cart
    cart_id = cookies[:cart_id]

    if cart_id
      @cart = Cart.find(cart_id)
    else
      @cart = Cart.create!(total_price: 0)
      cookies[cart_id] = @cart.id
    end
  end

  def product_params
    params.require(:cart).permit(:product_id, :quantity)
  end
end
