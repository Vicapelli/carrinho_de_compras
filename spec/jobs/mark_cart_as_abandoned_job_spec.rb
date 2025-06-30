require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe "#perform" do
    it "marks carts without updates for more than 3 hours as abandoned" do
      cart = create(:cart, :old)

      expect {
        described_class.new.perform
      }.to change { cart.reload.abandoned_at }.from(nil)
    end

    it "does not mark recently updated carts as abandoned" do
      cart = create(:cart, updated_at: 1.hour.ago)

      expect {
        described_class.new.perform
      }.not_to change { cart.reload.abandoned_at }
    end

    it "removes carts abandoned for more than 7 days" do
      cart = create(:cart, :abandoned_long_ago)

      expect {
        described_class.new.perform
      }.to change { Cart.exists?(cart.id) }.from(true).to(false)
    end

    it "does not remove recently abandoned carts" do
      cart = create(:cart, abandoned_at: 2.days.ago)

      expect {
        described_class.new.perform
      }.not_to change { Cart.exists?(cart.id) }
    end
  end
end