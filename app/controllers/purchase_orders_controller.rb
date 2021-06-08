
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
        @po = PurchaseOrder.find_by(id: params[:id])
        if valid_number?(params[:po][:po_authorized_amount]) 
            if Vendor.all.any? {|v| v.name == params[:vendor][:name].downcase}
                flash[:message] = "Vendor name already taken, please create another one!"
                redirect to "/purchase_orders/edit/#{params[:id]}"
            elsif params[:vendor][:name] != "" 
                new_vendor = Vendor.create(name: params[:vendor][:name].downcase)
                @po.vendor = new_vendor
                @po.save
            end
            if params[:vendor][:name] == "" 
                @po.update(vendor_id: params[:po][:vendor_id])
            end
            if Budget.all.any? {|b| b.name == params[:budget][:name].downcase}
                flash[:message] = "Budget name already taken, please create another one!"
                redirect to "/purchase_orders/edit/#{params[:id]}"
            elsif params[:budget][:name] != "" 
                new_budget = Budget.create(name: params[:budget][:name].downcase, target: params[:budget][:target])
                @po.budget = new_budget
                @po.save
                current_user.budgets << new_budget
                current_user.save
            end 
            if params[:budget][:name] == "" 
                @po.update(budget_id: params[:po][:budget_id])
            end
            @po.update(po_authorized_amount: params[:po][:po_authorized_amount])
            redirect to "/budgets/#{@po.budget.id}"
        else
            flash[:message] = "PO Authorized Amount must be numbers!"
            redirect to "/purchase_orders/edit/#{params[:id]}"
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