class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates_numericality_of :quantity, greater_than_or_equal_to: 0

  after_create :update_cart_total_price
  after_destroy :update_cart_total_price
  after_update :update_cart_total_price_if_needed

  def total_price
    self.quantity * self.product.price
  end

  private

  def update_cart_total_price
    cart.update(total_price: cart.total_price + self.total_price)
  end

  def update_cart_total_price_if_needed
    if saved_change_to_quantity? || saved_change_to_product_id?
      update_cart_total_price
    end
  end
end
