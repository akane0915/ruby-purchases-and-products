require 'rubysales/version'
require 'sinatra/activerecord'

module Rubysales
  class Product < ActiveRecord::Base
    belongs_to :purchase
    scope(:unpurchased, -> {where purchase_id: nil})
  end
  class Purchase < ActiveRecord::Base
    has_many :products
  end
end
