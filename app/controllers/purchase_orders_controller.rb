
class PurchaseOrdersController < ApplicationController
    
    get '/purchase_order/new' do
        if logged_in?
            erb :'purchase_orders/new_po'
        else
            redirect to '/user/login'
        end
    end

    post '/purchase_order' do
       if valid_number?(params[:po][:po_number]) && valid_number?(params[:po][:po_authorized_amout]) 
            @po = PurchaseOrder.create(params[:po])
            if !!params[:po][:vendor_id]
                new_vendor = Vendor.create(name: params[:vendor][:name])
                @po.vendor = new_vendor
            end
            if !!params[:po][:budget_id]
                new_budget = Budget.create(name: params[:budget][:name], target: params[:budget][:target])
                @po.budget = new_budget
            end
        else
            flash[:message] = "please enter only number for PO number and Authorized Amount!"
            redirect to '/pruchase_order/new'
        end
    end

end