
class UsersController < ApplicationController

    get '/signup' do
        if logged_in?
            redirect to "/users/#{current_user.slug}"
        else
            erb :'users/signup'
        end
    end

    post '/signup' do
        redirect_if_not_loggedin
        user = User.new(username: params[:username].downcase, password: params[:password])
        if user.valid? && valid_password?(params[:password])
            user.save
            session[:user_id] = user.id
            redirect to "/users/#{user.slug}"
        else
            if !valid_password?(params[:password]) 
                @errors = "Invalid password!"
                erb :'users/signup'
            else
                error_messages(@errors)
                # @errors = user.errors.messages.collect {|k, v| "#{k.to_s} #{v[0]}"}
                erb :'users/signup'
            end
        end
    end

    get '/login' do 
        if logged_in?
            user = User.find_by(id: session[:user_id])
            redirect to "users/#{user.slug}"
        else
            erb :'users/login'
        end
    end

    post '/login' do
        user = User.find_by(username: params[:username].downcase)
        if !!user && !!user.authenticate(params[:password])
            session[:user_id] = user.id
            flash[:message] = nil
            redirect to "users/#{user.slug}"
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

    get '/users/:slug' do
        redirect_if_not_loggedin
        @user = User.find_by_slug(params[:slug])
        correct_user?
        erb :'users/profile'
    end

    private
        def correct_user?
            if current_user != @user
                redirect to '/login'
            end
        end

end