require 'sidekiq-scheduler'

class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    mark_abandoned_carts
    delete_old_abandoned_carts
  end

  private

  def mark_abandoned_carts
    Cart.where(abandoned_at: nil)
        .where("updated_at < ?", 3.hours.ago)
        .find_each do |cart|
      cart.update_column(:abandoned_at, Time.current)
    end
  end

  def delete_old_abandoned_carts
    Cart.where("abandoned_at < ?", 7.days.ago).find_each do |cart|
      cart.destroy
    end
  end
end
