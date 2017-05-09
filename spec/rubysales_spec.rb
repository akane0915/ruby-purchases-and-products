require 'spec_helper'
require 'date'

RSpec.describe Rubysales do
  it 'has a version number' do
    expect(Rubysales::VERSION).not_to be nil
  end

  describe Rubysales::Product do
    before(:all) do
      @test_purchase = Rubysales::Purchase.create customer_name: 'Jon Snow'
      @test_product1 = Rubysales::Product.create name: 'book', purchase_id: @test_purchase.id
      @test_product2 = Rubysales::Product.create name: 'table'
    end
    it 'finds unpurchased products' do
      expect(Rubysales::Product.unpurchased).to eq [@test_product2]
    end
  end

  describe Rubysales::Purchase do
    before(:all) do
      t1 = DateTime.new(2015, 2, 3.5)
      Timecop.freeze(t1) do
        @test_purchase1 = Rubysales::Purchase.create customer_name: 'Jon Snow'
      end
      t2 = DateTime.new(2016, 2, 3.5)
      Timecop.freeze(t2) do
        @test_purchase2 = Rubysales::Purchase.create customer_name: 'Rob Stark'
      end
      t3 = DateTime.new(2017, 2, 3.5)
      Timecop.freeze(t3) do
        @test_purchase3 = Rubysales::Purchase.create customer_name: 'Jaime Lannister'
      end
    end
    it 'returns purchases transacted between a start date and end date' do
      expect(Rubysales::Purchase.between(DateTime.new(2016, 1, 1), DateTime.new(2017, 3, 1)))
        .to match_array [@test_purchase2, @test_purchase3]
    end
  end
end
