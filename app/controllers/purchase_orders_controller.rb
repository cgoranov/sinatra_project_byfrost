
class PurchaseOrdersController < ApplicationController
    
    get '/purchase_order/new' do
        if logged_in?
            erb :'purchase_orders/new_po'
        else
            redirect to '/user/login'
        end
    end

    post '/purchase_order' do
       if valid_number?(params[:po][:po_number]) && valid_number?(params[:po][:po_authorized_amount]) && !PurchaseOrder.all.any? {|p| p.po_number == params[:po][:po_number].to_i}
            if params[:po][:vendor_id] == "" && params[:vendor][:name] == ""       
                flash[:message] = "Either add or assign vendor to PO!"
                redirect to '/purchase_order/new'
            elsif params[:po][:budget_id] == "" && params[:budget][:name] == ""
                flash[:message] = "Either add or assign budget to PO!"
                redirect to '/purchase_order/new'
            elsif params[:po][:vendor_id] != "" && params[:vendor][:name] != ""       
                flash[:message] = "Please add or assign ONE vendor to PO!"
                redirect to '/purchase_order/new'
            elsif params[:po][:budget_id] != "" && params[:budget][:name] != ""
                flash[:message] = "Please add or assign ONE budget to PO!"
                redirect to '/purchase_order/new'
            else
                @po = PurchaseOrder.create(params[:po])
                if params[:po][:vendor_id] == ""
                    new_vendor = Vendor.create(name: params[:vendor][:name].downcase)
                    @po.vendor = new_vendor
                end
                if params[:vendor][:name] == ""
                    @po.update(vendor_id: params[:po][:vendor_id])
                end
                if params[:po][:budget_id] == ""
                    new_budget = Budget.create(name: params[:budget][:name].downcase, target: params[:budget][:target])
                    @po.budget = new_budget
                end
                if params[:budget][:name] == ""
                    @po.update(budget_id: params[:po][:budget_id])
                end
                redirect to "/budgets/#{@po.budget.id}"
            end
        else
            if PurchaseOrder.all.any? {|p| p.po_number == params[:po][:po_number].to_i}
                flash[:message] = "Cannot use existing PO number!"
                redirect to '/purchase_order/new'
            else
                flash[:message] = "PO Number and PO Authorized Amount must be numbers!"
                redirect to '/purchase_order/new'
            end
        end
    end

    get '/purchase_order/edit/:id' do
        if logged_in?
            @po = PurchaseOrder.find_by(id: params[:id])
            erb :'purchase_orders/po_edit'
        else
            redirect to '/user/login'
        end
    end

    patch '/purchase_order/edit/:id' do 
        @po = PurchaseOrder.find_by(id: params[:id])
        if valid_number?(params[:po][:po_authorized_amount]) 
            if Vendor.all.any? {|v| v.name == params[:vendor][:name].downcase}
                flash[:message] = "Vendor name already taken, please create another one!"
                redirect to "/purchase_order/edit/#{params[:id]}"
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
                redirect to "/purchase_order/edit/#{params[:id]}"
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
            redirect to "/purchase_order/edit/#{params[:id]}"
        end     
    end

    delete '/purchase_order/:id' do
        if logged_in?
            @po = PurchaseOrder.find_by(id: params[:id])
            budget = @po.budget
            @po.destroy
            redirect to "/budgets/#{budget.id}"
        else
            redirect to '/user/login'
        end
    end

end