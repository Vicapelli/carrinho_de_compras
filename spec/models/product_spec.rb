require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'when validating' do
    it 'validates presence of name' do
      product = described_class.new(price: 100)
      expect(product.valid?).to be_falsey
      expect(product.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of price' do
      product = described_class.new(name: 'name')
      expect(product.valid?).to be_falsey
      expect(product.errors[:price]).to include("can't be blank")
    end

    it 'validates numericality of price' do
      product = described_class.new(price: -1)
      expect(product.valid?).to be_falsey
      expect(product.errors[:price]).to include("must be greater than or equal to 0")
    end
  end

  # Usando shoulda-matchers
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  describe "associations" do
    it { should have_many(:cart_items) }
    it { should have_many(:carts).through(:cart_items) }
  end

end
