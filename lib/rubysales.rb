require 'rubysales/version'
require 'sinatra/activerecord'

module Rubysales
  class Product < ActiveRecord::Base
    belongs_to :purchase
    scope(:unpurchased, -> { where purchase_id: nil })
    validates :name, :description, :price, presence: true
    validates :name, with: /^[A-Za-z0-9]+$/
    validates :price, numericality: true
  end

  class Purchase < ActiveRecord::Base
    has_many :products
    scope(:between, lambda do |start_date, end_date|
      # binding.pry
      where "created_at BETWEEN '#{start_date.strftime('%Y-%m-%d %H:%M:%S')}'"\
       " AND '#{end_date.strftime('%Y-%m-%d %H:%M:%S')}'"
    end)
    validates(
      :customer_name, presence: true, length: { maximum: 50 },
                      with: /^[A-Za-z0-9]+$/
    )

    def total
      products.map(&:price).reduce(:+)
    end
  end
end

# Adds a method to the Hash class.
#
# @note We're extending the global object because, hey, if Rails can do it...
class Hash
  # Recursively turns string hash keys to symbols.
  #
  # The key must respond to to_sym. So basically just strings.
  # @return A new hash with symbols instead of string keys.
  def symbolize
    # changing this to use responds_to? because it's more Ruby-ish
    # in Smalltalk-influenced OO languages method calls simply send a message
    # to the object the method is being called on
    # the idea of 'duck typing' is that we don't care if it *is* a duck
    # we just care if it quacks like one
    Hash[map { |k, v| [k.to_sym, v.respond_to?(:symbolize) ? v.symbolize : v] }]
  end
end
