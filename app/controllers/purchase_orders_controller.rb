
class PurchaseOrdersController < ApplicationController
    
    get '/purchase_orders/new' do
        redirect_if_not_loggedin
        erb :'purchase_orders/new'
    end

    post '/purchase_orders' do
        @new_po = PurchaseOrder.new(params[:po])
        if @new_po.valid?
            @new_po.save
            redirect to "/budgets/#{@new_po.budget.id}"
        else
            @errors = @new_po.errors.messages.collect {|k, v| "#{k.to_s} #{v[0]}"}
            erb :'purchase_orders/new'
        end
    end

    get '/purchase_orders/:id/edit' do
        redirect_if_not_loggedin
        @po = PurchaseOrder.find_by(id: params[:id])
        erb :'purchase_orders/edit'
    end

    patch '/purchase_orders/:id' do 
        redirect_if_not_loggedin
        @po = PurchaseOrder.find_by(id: params[:id])
        @edit = PurchaseOrder.new(params[:po])
        @edit.valid?
        if @edit.errors.details[:po_authorized_amount].empty? && @edit.errors.details[:vendor_id].empty? && @edit.errors.details[:budget_id].empty? 
            @po.update(params[:po])
            redirect to "/budgets/#{@po.budget.id}"
        else
            @edit.errors.messages.delete(:po_number)
            @errors = @edit.errors.messages.collect {|k, v| "#{k.to_s} #{v[0]}"}
            erb :'purchase_orders/edit'
        end
    end

    delete '/purchase_orders/:id/delete' do
        redirect_if_not_loggedin
        @po = PurchaseOrder.find_by(id: params[:id])
        budget = @po.budget
        @po.destroy
        redirect to "/budgets/#{budget.id}"
    end

end