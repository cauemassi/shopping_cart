class CartsController < ApplicationController
  include ActionController::Cookies

  before_action :set_cart

  def create
    @cart_item = CartItem.new(cart: @cart, product_id: params[:product_id], quantity: params[:quantity])

    @cart_item.save!

    render json: @cart
  end

  def show
    render json: @cart
  end

  def add_items
    @cart_item = CartItem.find_by(cart: @cart, product: params[:product_id])

    if @cart_item
      @cart_item.quantity += params[:quantity]

      @cart_item.save!
    else
      render json: "Product is not in the cart to be added. Please first add Product", status: :unprocessable_entity
    end
  end

  def delete_items
    @cart_item = CartItem.find_by(cart: @cart, product: params[:product_id])

    if @cart_item
      @cart_item.destroy!
    else
      render json: "Product is not in the cart to be deleted", status: :unprocessable_entity
    end
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
end
