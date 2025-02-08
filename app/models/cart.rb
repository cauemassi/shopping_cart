class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  has_many :cart_items

  def mark_as_abandoned
    if last_interaction_at <= 3.hours.ago
      self.update(abandoned: true)      
    end
  end

  def remove_if_abandoned
    if last_interaction_at <= 7.days.ago
      self.destroy!  
    end
  end
end
