require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "validations" do
    it { should validate_numericality_of(:total_price).is_greater_than_or_equal_to(0) }
  end

  describe "associations" do
    it { should have_many(:cart_items).dependent(:destroy) }
    it { should have_many(:products).through(:cart_items) }
  end

  describe "#total_price" do
    it "returns the sum of cart_items total_price" do
      cart = create(:cart)
      product = create(:product, price: 10.0)
      product2 = create(:product, price: 20.0)
      create(:cart_item, cart: cart, product: product, quantity: 2)
      create(:cart_item, cart: cart, product: product2, quantity: 1)

      expect(cart.reload.total_price).to eq(40.0)
    end

    it "returns 0 when cart has no items" do
      cart = create(:cart)
      expect(cart.total_price).to eq(0)
    end
  end
end
