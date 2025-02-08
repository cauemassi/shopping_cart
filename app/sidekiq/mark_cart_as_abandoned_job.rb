class MarkCartAsAbandonedJob
  include Sidekiq::Job
  queue_as :default

  def perform
    carts = Cart.where(abandoned: false)
    carts.each do |cart|
      cart.mark_as_abandoned
    end
  end
end