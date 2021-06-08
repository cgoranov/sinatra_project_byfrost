
class UsersController < ApplicationController

    get '/signup' do
        if logged_in?
            redirect to "/#{current_user.slug}"
        else
            erb :'users/signup'
        end
    end

    post '/signup' do
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

    get '/login' do 
        if logged_in?
            user = User.find_by(id: session[:user_id])
            redirect to "/#{user.slug}"
        else
            erb :'users/login'
        end
    end

    post '/login' do
        user = User.find_by(username: params[:username].downcase)
        if !!user && !!user.authenticate(params[:password])
            session[:user_id] = user.id
            flash[:message] = nil
            redirect to "/#{user.slug}"
        else
            flash[:message] = "Invalid Username or Password. Please try again!"
            redirect to '/login'
        end
    end

    post '/logout' do 
        redirect_if_not_loggedin
        session.clear
        redirect to '/'
    end

    delete '/delete' do
        redirect_if_not_loggedin
        current_user.destroy
        redirect to '/'
    end

    get '/:slug' do
        redirect_if_not_loggedin
        @user = User.find_by_slug(params[:slug])
        erb :'users/profile'
    end

end