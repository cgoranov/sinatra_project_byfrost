
class UsersController < ApplicationController

    get '/signup' do
       if logged_in?
            redirect to '/budgets'
       else
            erb :'users/sign_up'
       end
    end

    post '/signup' do
        if valid_password?(params[:password]) && params[:username].between?(6, 10) && User.all.any? {|u| u.username == params[:username].downcase}
            user = User.create(useranme: params[:username].downcase, password: params[:password])
            session[:user_id] = user.id
            erb :budgets
        else
            flash[:message] = "Username and password did not meet criteria. Please try again!"
            erb :sign_up
        end

    end

end