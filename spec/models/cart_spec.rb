# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include('must be greater than or equal to 0')
    end
  end

  describe 'mark_as_abandoned' do
    let(:shopping_cart) { FactoryBot.create(:shopping_cart) }

    it 'marks the shopping cart as abandoned if inactive for a certain time' do
      shopping_cart.update(last_interaction_at: 3.hours.ago)
      expect { shopping_cart.mark_as_abandoned }.to change { shopping_cart.abandoned? }.from(false).to(true)
    end
  end

  describe 'keep_cart_active' do
    let(:shopping_cart) { FactoryBot.create(:shopping_cart) }

    it 'dont change to abandoned' do
      shopping_cart.update(last_interaction_at: 1.hour.ago)
      expect(shopping_cart.abandoned).to eq(false)
    end
  end

  describe 'remove_if_abandoned' do
    let(:shopping_cart) { FactoryBot.create(:shopping_cart, last_interaction_at: 7.days.ago) }

    it 'removes the shopping cart if abandoned for a certain time' do
      shopping_cart.mark_as_abandoned
      expect { shopping_cart.remove_if_abandoned }.to change { Cart.count }.by(-1)
    end
  end

  describe 'dont_remove_if_abandoned' do
    let(:shopping_cart) { FactoryBot.create(:shopping_cart, last_interaction_at: 3.days.ago) }

    it 'dont removes the shopping cart if abandoned for a certain time' do
      shopping_cart.mark_as_abandoned
      expect { shopping_cart.remove_if_abandoned }.to change { Cart.count }.by(0)
    end
  end

  context 'relations' do
    it { is_expected.to have_many(:cart_items) }
  end
end
