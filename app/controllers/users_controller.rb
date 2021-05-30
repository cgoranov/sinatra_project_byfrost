
class UsersController < ApplicationController

    get '/signup' do
       if logged_in?
            redirect to '/budgets'
       else
            erb :'users/sign_up'
       end
    end

    post '/signup' do
        if valid_password?(params[:password]) && params[:username].length.between?(6, 10) && !User.all.any? {|u| u.username == params[:username].downcase}
            user = User.create(username: params[:username].downcase, password: params[:password])
            session[:user_id] = user.id
            redirect to '/budgets'
        else
            if valid_password?(params[:password]) && params[:username].length.between?(6, 10) && User.all.any? {|u| u.username == params[:username].downcase}
                flash[:message] = "Username already taken! Please try again!"
                erb :'users/sign_up'
            else
                flash[:message] = "Username and password did not meet criteria. Please try again!"
                erb :'users/sign_up'
            end 
        end
    end

    get '/login' do 
        if !logged_in?
            erb :'users/log_in'
        else
            user = User.find_by(id: session[:user_id])
            redirect to "/#{user.slug}"
        end
    end

    get '/:slug' do
        if logged_in?
            @user = User.find_by_slug(params[:slug])
            erb :user_profile
        else
            redirect to "/login"
        end
    end


end