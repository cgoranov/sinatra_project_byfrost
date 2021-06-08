
class BudgetsController < ApplicationController

    get '/budgets' do
        redirect_if_not_loggedin       
        @user = current_user
        erb :'budgets/index'
    end

    get '/budgets/new' do
        redirect_if_not_loggedin
        erb :'budgets/new'
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
        redirect_if_not_loggedin
        @budget = Budget.find_by(id: params[:id])
        current_user_budget?
        @open_po_sum = 0
        erb :'budgets/show'
    end

    get '/budgets/:id/edit' do
        redirect_if_not_loggedin
        @budget = Budget.find_by(id: params[:id])
        current_user_budget?
        erb :'budgets/edit'
    end

    patch '/budgets/:id' do
        @budget = Budget.find_by(id: params[:id])
        current_user_budget?
        if valid_number?(params[:budget][:target])
            if params[:budget][:target] == "" || params[:budget][:name] == ""
                flash[:message] = "Must input value for name and target."
                redirect to "/budgets/#{@budget.id}/edit"
            else
                @budget.update(name: params[:budget][:name].downcase, target: params[:budget][:target])
                redirect to "/budgets/#{@budget.id}"
            end
        else
            redirect to "/budgets/edit/#{@budget.id}"
        end
    end

    delete '/budgets/:id/delete' do
        redirect_if_not_loggedin
        @budget = Budget.find_by(id: params[:id])
        current_user_budget?
        @budget.destroy
        redirect to '/budgets'
    end
    
    private
        def current_user_budget?
            if !current_user.budgets.include?(@budget)
                redirect to '/budgets'
            end
        end

end