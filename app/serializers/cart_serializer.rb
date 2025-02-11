# frozen_string_literal: true

class CartSerializer < ActiveModel::Serializer
  attributes :id, :products, :total_price
  def products
    object.cart_items.map do |cart_item|
      {
        id: cart_item.product.id,
        name: cart_item.product.name,
        quantity: cart_item.quantity,
        unit_price: cart_item.product.price,
        total_price: cart_item.total_price
      }
    end
  end
end
