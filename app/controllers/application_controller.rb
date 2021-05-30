
class ApplicationController < Sinatra::Base

    use Rack::Flash

    configure do
        enable :sessions
        set :session_secret, SESSION_SECRET
    end 

    get '/' do
     
    end

end