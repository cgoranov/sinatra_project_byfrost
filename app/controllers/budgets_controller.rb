
class BudgetsController < ApplicationController

    get '/budgets' do
        if logged_in?
            erb :'budgets/show_all_budgets'
        else
            redirect to '/'
        end
    end
    
end