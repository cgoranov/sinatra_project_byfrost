
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
            erb :'budgets/new_budget'
        else
            redirect to '/login'
        end
    end

    post '/budgets' do
        new_budget = Budget.create(name: params[:name].downcase, target: params[:target])
        current_user.budgets << new_budget
        current_user.save
        redirect to '/budgets'
    end
    
end