ENV["SINATRA_ENV"] ||= "development"

SESSION_SECRET = SecureRandom.hex(64)

require 'bundler/setup'
Bundler.require(:default, ENV["SINATRA_ENV"]) 

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "db/#{ENV["SINATRA_ENV"]}.sqlite3")

require_all 'app'