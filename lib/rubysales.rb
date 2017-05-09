require 'rubysales/version'
require 'sinatra/activerecord'

module Rubysales
  class Product < ActiveRecord::Base
    belongs_to :purchase
  end
  class Purchase < ActiveRecord::Base
    has_many :products
  end
end
