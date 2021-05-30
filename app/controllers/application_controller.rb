require 'rack-flash'

class ApplicationController < Sinatra::Base

    use Rack::Flash

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, SESSION_SECRET
    end 

    get '/' do
        erb :main_menu
    end

end