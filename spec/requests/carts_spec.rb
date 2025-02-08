require 'rails_helper'

RSpec.describe "/carts", type: :request do
  pending "TODO: Escreva os testes de comportamento do controller de carrinho necessários para cobrir a sua implmentação #{__FILE__}"
  describe "POST /add_items" do
    let(:cart) { Cart.create!(total_price: 0) }
    let(:product) { Product.create!(name: "Test Product", price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    before do
      cookies[:cart_id] = cart.id
    end

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end

  describe "DELETE cart/delete_items" do
    let(:cart) { Cart.create!(total_price: 0) }
    let(:product) { Product.create!(name: "Test Product", price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    before do
      cookies[:cart_id] = cart.id
    end

    context 'delete product of cart' do
      subject do
        delete delete_item_cart_url(product.id)
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change(CartItem, :count).by(-1)
      end
    end
  end
end
