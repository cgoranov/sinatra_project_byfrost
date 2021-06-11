
class PurchaseOrdersController < ApplicationController
    
    get '/purchase_orders/new' do
        redirect_if_not_loggedin
        binding.pry
        erb :'purchase_orders/new'
    end

    post '/purchase_orders' do
        @new_po = PurchaseOrder.new(params[:po])
        if @new_po.valid?
            @new_po.save
            redirect to "/budgets/#{@new_po.budget.id}"
        else
            error_messages(@new_po)
            # @errors = @new_po.errors.messages.collect {|k, v| "#{k.to_s} #{v[0]}"}
            erb :'purchase_orders/new'
        end
    end

    get '/purchase_orders/:id/edit' do
        redirect_if_not_loggedin
        @po = PurchaseOrder.find_by(id: params[:id])
        current_user_po?(@po)
        erb :'purchase_orders/edit'
    end

    patch '/purchase_orders/:id' do 
        redirect_if_not_loggedin
        @po = PurchaseOrder.find_by(id: params[:id])
        current_user_po?(@po)
        @edit = PurchaseOrder.new(params[:po])
        @edit.valid?
        if @edit.errors.details[:po_authorized_amount].empty? && @edit.errors.details[:vendor_id].empty? && @edit.errors.details[:budget_id].empty? 
            @po.update(params[:po])
            redirect to "/budgets/#{@po.budget.id}"
        else
            @edit.errors.messages.delete(:po_number)
            error_messages(@edit)
            # @errors = @edit.errors.messages.collect {|k, v| "#{k.to_s} #{v[0]}"}
            erb :'purchase_orders/edit'
        end
    end

    delete '/purchase_orders/:id' do
        redirect_if_not_loggedin
        @po = PurchaseOrder.find_by(id: params[:id])
        current_user_po?(@po)
        budget = @po.budget
        @po.destroy
        redirect to "/budgets/#{budget.id}"
    end

    private
        def current_user_po?(po)
            if po.budget.user != current_user 
                redirect to '/budgets'
            end
        end

end