require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe "associations" do
    it { should belong_to(:cart) }
    it { should belong_to(:product) }
  end

  describe "validations" do
    it {
      should validate_numericality_of(:quantity).
        is_greater_than(0).
        only_integer
    }
  end

  describe "#total_price" do
    it "returns the product price multiplied by quantity" do
      product = create(:product, price: 12.5)
      cart_item = create(:cart_item, product: product, quantity: 3)

      expect(cart_item.total_price).to eq(37.5)
    end
  end
end
