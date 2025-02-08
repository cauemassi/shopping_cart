require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe '#perform' do
    let!(:recent_cart) { FactoryBot.create(:shopping_cart, abandoned: false, last_interaction_at: 2.hours.ago) }
    let!(:old_cart) { FactoryBot.create(:shopping_cart, abandoned: false, last_interaction_at: 4.hours.ago) }
    let!(:already_abandoned_cart) { FactoryBot.create(:shopping_cart, abandoned: true, last_interaction_at: 5.hours.ago) }

    it 'marks old carts as abandoned' do
      expect(old_cart.abandoned).to be_falsey

      MarkCartAsAbandonedJob.new.perform

      old_cart.reload
      expect(old_cart.abandoned).to be_truthy
    end

    it 'does not mark recent carts as abandoned' do
      expect(recent_cart.abandoned).to be_falsey

      MarkCartAsAbandonedJob.new.perform

      recent_cart.reload
      expect(recent_cart.abandoned).to be_falsey
    end

    it 'does not change already abandoned carts' do
      expect(already_abandoned_cart.abandoned).to be_truthy

      MarkCartAsAbandonedJob.new.perform

      already_abandoned_cart.reload
      expect(already_abandoned_cart.abandoned).to be_truthy
    end
  end
end