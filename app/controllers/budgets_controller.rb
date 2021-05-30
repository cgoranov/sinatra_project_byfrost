
class BudgetsController < ApplicationController

    get '/budgets' do
        erb :'budgets/show_all_budgets'
    end
    
end