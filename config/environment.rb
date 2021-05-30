ENV["SINATRA_ENV"] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV["SINATRA_ENV"]) 

SESSION_SECRET = Sysrandom.hex(64)

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "db/#{ENV["SINATRA_ENV"]}.sqlite3")

require_all 'app'