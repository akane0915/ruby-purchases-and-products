require 'rubysales/version'
require 'sinatra/activerecord'

module Rubysales
  class Product < ActiveRecord::Base
    belongs_to :purchase
    scope(:unpurchased, -> { where purchase_id: nil })
  end
  class Purchase < ActiveRecord::Base
    has_many :products
    scope(:between, lambda do |start_date, end_date|
      # binding.pry
      where "created_at BETWEEN '#{start_date.strftime('%Y-%m-%d %H:%M:%S')}'"\
       " AND '#{end_date.strftime('%Y-%m-%d %H:%M:%S')}'"
    end)
  end
end
