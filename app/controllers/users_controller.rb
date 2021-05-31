
class UsersController < ApplicationController

    get '/user/signup' do
       if logged_in?
            user = User.find_by(id: session[:user_id])
            redirect to "/user/#{user.slug}"
       else
            erb :'users/sign_up'
       end
    end

    post '/user/signup' do
        if valid_password?(params[:password]) && params[:username].length.between?(6, 10) && !User.all.any? {|u| u.username == params[:username].downcase}
            user = User.create(username: params[:username].downcase, password: params[:password])
            session[:user_id] = user.id
            flash[:messsage] = nil
            redirect to "/user/#{user.slug}"
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

    get '/user/login' do 
        if !logged_in?
            erb :'users/log_in'
        else
            user = User.find_by(id: session[:user_id])
            redirect to "/user/#{user.slug}"
        end
    end

    post '/user/login' do
        user = User.find_by(username: params[:username].downcase)
        if !!user && !!user.authenticate(params[:password])
            session[:user_id] = user.id
            flash[:message] = nil
            redirect to "/user/#{user.slug}"
        else
            flash[:message] = "Invalid Username or Password. Please try again!"
            redirect to '/user/login'
        end
    end

    get '/user/logout' do 
        if logged_in?
            session.clear
            redirect to '/'
        else
            redirect to '/user/login'
        end
    end

    delete '/user/delete' do
        if logged_in?
            current_user.destroy
            redirect to '/'
        else
            redirect to "/user/login"
        end
    end

    get '/user/:slug' do
        if logged_in?
            @user = User.find_by_slug(params[:slug])
            erb :'users/user_profile'
        else
            redirect to "/user/login"
        end
    end

   
end