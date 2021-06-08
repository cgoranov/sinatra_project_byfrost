
class UsersController < ApplicationController

    get '/signup' do
        if logged_in?
            redirect to "/#{current_user.slug}"
        else
            erb :'users/signup'
        end
    end

    post '/signup' do
        user = User.new(params)
        if user.valid?
        
        else
            @errors = user.errors.messages.collect {|k, v| "#{k.to_s} #{v[0]}"}
            erb :'users/signup'
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