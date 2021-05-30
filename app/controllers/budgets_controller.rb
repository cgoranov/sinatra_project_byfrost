
class BudgetsController < ApplicationController

    get '/budgets' do
        if logged_in?
            @user = current_user
            erb :'budgets/show_all_budgets'
        else
            redirect to '/'
        end
    end
    
end