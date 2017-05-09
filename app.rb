require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'pry-byebug'

if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end
class RubysalesApp < Sinatra::Application
  def params
    params.symbolize
  end

  get('/') do
    erb(:index)
  end

  get('/products') do
    @products = Rubysales::Product.all
    erb(:products)
  end

  get('/products/:id') do
    @product = Rubysales::Product.find(params.fetch(:id))
    erb(:product)
  end

  get('/products/new') do
    @purchases = Rubysales::Purchase.all
    erb(:new_product)
  end

  post('/products') do
    product = params.fetch(:product)
    Rubysales::Product.create(product)
    redirect '/products'
  end

  patch('/products/:id') do
    new_data = params.fetch(:product)
    @product = Rubysales::Product.update(params.fetch(:id), new_data)
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

  get('/purchases/:id') do
    @purchase = Rubysales::Purchase.find(params.fetch(:id))
    erb(:purchase)
  end

  get('/purchases/new') do
    erb(:new_purchase)
  end

  post('/purchases') do
    purchase = params.fetch(:purchase)
    Rubysales::Purchase.create(purchase)
    redirect '/purchases'
  end

  patch('/purchases/:id') do
    new_data = params.fetch(:purchase)
    @purchase = Rubysales::Purchase.update(params.fetch(:id), new_data)
    erb(:purchase)
  end

  delete('/purchases/:id') do
    Rubysales::Purchase.destroy(params.fetch(:id))
    redirect('/purchases')
  end
end
