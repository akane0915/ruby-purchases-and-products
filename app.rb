require 'sinatra'
require 'sinatra/activerecord'
require 'rake'
require 'sinatra/activerecord/rake'
require 'pry-byebug'
require 'rubysales'

if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end
class RubysalesApp < Sinatra::Application
  def params
    super.symbolize
  end

  get('/') do
    @products = Rubysales::Product.unpurchased
    erb(:index)
  end

  get('/products') do
    @products = Rubysales::Product.all
    erb(:products)
  end

  get('/products/new') do
    @purchases = Rubysales::Purchase.all
    erb(:new_product)
  end

  get('/products/:id') do
    @product = Rubysales::Product.find(params.fetch(:id))
    @purchases = Rubysales::Purchase.all
    erb(:product)
  end


  post('/products') do
    binding.pry
    product = params.fetch(:product)
    Rubysales::Product.create(product)
    redirect '/products'
  end

  patch('/products/:id') do
    new_data = params.fetch(:product)
    @product = Rubysales::Product.update(params.fetch(:id), new_data)
    @purchases = Rubysales::Purchase.all
    erb(:product)
  end

  delete('/products/:id') do
    Rubysales::Product.destroy(params.fetch(:id))
    redirect('/products')
  end

  get('/purchases') do
    @purchases = Rubysales::Purchase.all
    erb(:purchases)
  end

  get('/purchases/new') do
    @products = Rubysales::Product.unpurchased
    erb(:new_purchase)
  end

  get('/purchases/:id') do
    @purchase = Rubysales::Purchase.find(params.fetch(:id))
    @products = Rubysales::Product.all
    erb(:purchase)
  end


  post('/purchases') do
    purchase = params.fetch(:purchase)
    p_id = Rubysales::Purchase.create(purchase).id
    products = params.fetch(:products)
    binding.pry
    products.each do |hash|
      Rubysales::Product.update(hash[:id], purchase_id: p_id)
    end
    redirect '/purchases'
  end

  patch('/purchases/:id') do
    new_data = params.fetch(:purchase)
    id = params.fetch(:id)
    @purchase = Rubysales::Purchase.update(params.fetch(:id), new_data)
    Rubysales::Product.where(purchase_id: id).update(purchase_id: nil)
    products = params.fetch(:product)
    products.each do |product|
      Rubysales::Product.update(product[:id], purchase_id: id)
    end
    @products = Rubysales::Product.all
    erb(:purchase)
  end

  delete('/purchases/:id') do
    id = params.fetch(:id)
    Rubysales::Purchase.destroy(id)
    Rubysales::Product.where(purchase_id: id).each do |product|
      product.update(purchase_id: nil)
    end
    redirect('/purchases')
  end

  run! if app_file == $0
end
