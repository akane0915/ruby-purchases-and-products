require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'pry-byebug'

if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end

get('/') do
  erb(:index)
end
