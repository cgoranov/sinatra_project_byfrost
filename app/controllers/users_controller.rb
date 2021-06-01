
class UsersController < ApplicationController

    get '/user/new' do
        if logged_in?
            user = User.find_by(id: session[:user_id])
            redirect to "/user/#{user.slug}"
        else
            erb :'users/new'
        end
    end

    post '/user' do
        if valid_password?(params[:password]) && params[:username].length.between?(6, 10) && !User.all.any? {|u| u.username == params[:username].downcase}
            user = User.create(username: params[:username].downcase, password: params[:password])
            session[:user_id] = user.id
            flash[:messsage] = nil
            redirect to "/user/#{user.slug}"
        else
            if valid_password?(params[:password]) && params[:username].length.between?(6, 10) && User.all.any? {|u| u.username == params[:username].downcase}
                flash[:message] = "Username already taken! Please try again!"
                erb :'users/new'
            else
                flash[:message] = "Username and password did not meet criteria. Please try again!"
                erb :'users/new'
            end 
        end
    end

    get '/user/login' do 
        if logged_in?
            user = User.find_by(id: session[:user_id])
            redirect to "/user/#{user.slug}"
        else
            erb :'users/log_in'
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
        redirect_if_not_loggedin
        session.clear
        redirect to '/'
    end

    delete '/user/delete' do
        redirect_if_not_loggedin
        current_user.destroy
        redirect to '/'
    end

    get '/user/:slug' do
        redirect_if_not_loggedin
        @user = User.find_by_slug(params[:slug])
        erb :'users/user_profile'
    end

end