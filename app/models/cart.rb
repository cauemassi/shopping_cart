# frozen_string_literal: true

class Cart < ApplicationRecord
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  has_many :cart_items, dependent: :destroy

  def mark_as_abandoned
    return unless last_interaction_at <= 3.hours.ago

    update(abandoned: true)
  end

  def remove_if_abandoned
    return unless last_interaction_at <= 7.days.ago

    destroy!
  end
end
