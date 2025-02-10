require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context 'relations' do
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to belong_to(:product) }
  end

  context 'validations' do
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end

  context 'Update total price' do

    let(:cart) { FactoryBot.create(:shopping_cart) }
    let(:product) { Product.create!(name: "Test Product", price: 10.0) }
    let(:cart_item) { CartItem.create!(cart: cart, product: product, quantity: 3) }

    it 'calculate cart item and cart total price in creation of cart item' do
      expect(cart_item.total_price).to eq (cart_item.quantity * product.price)

      expect(cart.total_price).to eq (cart_item.quantity * product.price)
    end

    it 'calculate cart item and cart total price in update of cart item' do
      cart_item.update!(quantity: 3)

      expect(cart_item.total_price).to eq (cart_item.quantity * product.price)

      expect(cart.total_price).to eq (cart_item.quantity * product.price)
    end
  end
end