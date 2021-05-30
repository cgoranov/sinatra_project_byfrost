require 'rack-flash'

class ApplicationController < Sinatra::Base

    use Rack::Flash

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "sjlfkeijesljfkdjfsidesisdkjfjkljk887l"
    end 

    get '/' do
        erb :main_menu
    end

    helpers do 

        def current_user
            current_user ||= User.find_by(id: session[:user_id])
        end

        def logged_in? 
            !!current_user
        end

        def format_number(number)
            input = number.to_s
            if input.include?(".")
                fractional = input.split(".")[1]
                integral = input.split(".")[0]
                integral_with_commas = integral.to_s.reverse.scan(/.{1,3}/).join(',').reverse
                integral_with_commas + "." + fractional
            else
                input.to_s.reverse.scan(/.{1,3}/).join(',').reverse
            end
        end

    private
        def valid_password?(password)
            special_characters = "!#$%&'()*+,-./:;<=>?@[\]^_`{|}~"
            sc_array = special_characters.split("")
            sc_array.any? {|c| password.include?(c)} && password.length.between?(6, 10) 
        end
    end

end