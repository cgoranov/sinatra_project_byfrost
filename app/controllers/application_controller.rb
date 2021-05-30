
class ApplicationController < Sinatra::Base

    use Rack::Flash

    configure do
        enable :sessions
        set :session_secret, "secret"
    end 

end