
require 'bundler/setup'
Bundler.require(:default, :development) 

configure :development do
    set :database, 'sqlite3:db/project_byfrost.db'
end 

require_all 'app'