
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
        if valid_number?(params[:target])  
            new_budget = Budget.create(name: params[:name].downcase, target: params[:target])
            current_user.budgets << new_budget
            current_user.save
            redirect to '/budgets'
        else
            flash[:message] = "Not a valid Target. Please use only numbers!"
            redirect to '/budgets/new'
        end
    end

    get '/budgets/:id' do
        if logged_in?
            @budget = Budget.find_by(id: params[:id])
            @open_po_sum = 0
            erb :'budgets/budget_dashboard'
        else
            redirect to '/user/login'
        end
    end

    delete '/budgets/:id' do
        if logged_in?
            @budget = Budget.find_by(id: params[:id])
            @budget.destroy
            redirect to '/budgets'
        else
            redirect to '/user/login'
        end
    end
    
end