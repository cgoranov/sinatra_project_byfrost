
class BudgetsController < ApplicationController

    get '/budgets' do
        if logged_in?
            @user = current_user
            erb :'budgets/show_all_budgets'
        else
            redirect to '/'
        end
    end

    get '/budgets/new' do
        if logged_in?
            erb :new_budget
        else
            redirect to '/login'
        end
    end
    
end