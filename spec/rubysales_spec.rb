require 'spec_helper'

RSpec.describe Rubysales do
  it 'has a version number' do
    expect(Rubysales::VERSION).not_to be nil
  end

  describe Rubysales::Product do
    before(:all) do
      @test_purchase = Purchase.create customer_name: 'Jon Snow'
      @test_product1 = Product.create name: 'book', purchase_id: @test_purchase.id
      @test_product2 = Product.create name: 'table'
    end
    it 'finds unpurchased products' do
      expect(Product.unpurchased).to eq @test_product2
    end
  end

  describe Rubysales::Purchase do
  end
end
