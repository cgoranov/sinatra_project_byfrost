
class UsersController < ApplicationController

    get '/signup' do
       if logged_in?
            redirect to '/:slug/budgets'
       else
            erb :sign_up
       end
    end
    
end