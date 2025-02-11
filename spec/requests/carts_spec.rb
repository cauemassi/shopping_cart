# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/carts', type: :request do
  describe 'POST /cart' do
    context 'create product in cart' do
      let(:cart) { FactoryBot.create(:shopping_cart) }
      let(:product) { Product.create!(name: 'Test Product', price: 10.0) }

      before do
        cookies[:cart_id] = cart.id
      end
      subject do
        post '/cart', params: { product_id: product.id, quantity: 2 }
      end

      it 'can see cart informations' do
        subject

        response_body = response.parsed_body

        expected_array = {
          'id' => cart.id,
          'products' => [
            {
              'id' => product.id,
              'name' => product.name,
              'quantity' => 2,
              'unit_price' => product.price.to_s,
              'total_price' => (2 * product.price).to_s
            }
          ],
          'total_price' => (2 * product.price).to_s
        }

        expect(response_body).to eq expected_array
      end
    end

    context 'create product and cart' do
      let(:product) { Product.create!(name: 'Test Product', price: 10.0) }

      before do
        cookies[:cart_id] = nil
      end
      subject do
        post '/cart', params: { product_id: product.id, quantity: 2 }
      end

      it 'can see cart informations' do
        subject

        response_body = response.parsed_body

        expected_array = {
          'id' => Cart.first.id,
          'products' => [
            {
              'id' => product.id,
              'name' => product.name,
              'quantity' => 2,
              'unit_price' => product.price.to_s,
              'total_price' => (2 * product.price).to_s
            }
          ],
          'total_price' => (2 * product.price).to_s
        }

        expect(response_body).to eq expected_array
      end
    end

    context 'cant create product because already exist in cart' do
      let(:cart) { FactoryBot.create(:shopping_cart) }
      let(:product) { Product.create!(name: 'Test Product', price: 10.0) }
      let!(:cart_item) { CartItem.create!(cart: cart, product: product, quantity: 3) }

      before do
        cookies[:cart_id] = cart.id
      end
      subject do
        post '/cart', params: { product_id: product.id, quantity: 2 }
      end

      it 'can see error' do
        subject

        expect(response.body).to eq('Product already exist in cart. Please add product in cart')
      end
    end
  end

  describe 'SHOW /cart' do
    let(:cart) { FactoryBot.create(:shopping_cart) }
    let(:product) { Product.create!(name: 'Test Product', price: 10.0) }
    let(:product2) { Product.create!(name: 'Test Product 2', price: 40.0) }
    let!(:cart_item) { CartItem.create!(cart: cart, product: product, quantity: 3) }
    let!(:cart_item2) { CartItem.create!(cart: cart, product: product2, quantity: 2) }

    before do
      cookies[:cart_id] = cart.id
    end

    context 'show cart with products' do
      subject do
        get '/cart'
      end

      it 'can see cart informations' do
        subject

        response_body = response.parsed_body

        expected_array = {
          'id' => cart.id,
          'products' => [
            {
              'id' => product.id,
              'name' => product.name,
              'quantity' => cart_item.quantity,
              'unit_price' => product.price.to_s,
              'total_price' => (cart_item.quantity * product.price).to_s
            },
            {
              'id' => product2.id,
              'name' => product2.name,
              'quantity' => cart_item2.quantity,
              'unit_price' => product2.price.to_s,
              'total_price' => (cart_item2.quantity * product2.price).to_s
            }
          ],
          'total_price' => ((cart_item.quantity * product.price) + (cart_item2.quantity * product2.price)).to_s
        }

        expect(response_body).to eq expected_array
      end
    end
  end

  describe 'POST /add_items' do
    let(:cart) { FactoryBot.create(:shopping_cart) }
    let(:product) { Product.create!(name: 'Test Product', price: 10.0) }

    before do
      cookies[:cart_id] = cart.id
    end

    context 'when the product already is in the cart' do
      let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end

    context 'when the product not is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        subject

        expect(response.body).to eq('Product is not in the cart to be added. Please first add Product')
      end
    end
  end

  describe 'DELETE cart/delete_items' do
    let(:cart) { FactoryBot.create(:shopping_cart) }
    let(:product) { Product.create!(name: 'Test Product', price: 10.0) }

    before do
      cookies[:cart_id] = cart.id
    end

    context 'delete product of cart' do
      let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }
      subject do
        delete delete_item_cart_url(product.id)
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change(CartItem, :count).by(-1)
      end
    end

    context 'cant delete product that not in cart' do
      subject do
        delete delete_item_cart_url(product.id)
      end

      it 'updates the quantity of the existing item in the cart' do
        subject

        expect(response.body).to eq('Product is not in the cart to be deleted')
      end
    end
  end
end
