class CartSerializer < ActiveModel::Serializer
  attributes :id, :cart_items, :total_price
end
