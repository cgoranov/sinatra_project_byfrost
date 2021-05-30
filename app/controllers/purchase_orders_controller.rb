
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
                flash[:message] = "please add or assign vendor to PO!"
                redirect to '/purchase_order/new'
            elsif params[:po][:budget_id] == "" && params[:budget][:name] == ""
                flash[:message] = "please add or assign budget to PO!"
                redirect to '/purchase_order/new'
            elsif params[:po][:vendor_id] != "" && params[:vendor][:name] != ""       
                flash[:message] = "please add or assign ONE vendor to PO!"
                redirect to '/purchase_order/new'
            elsif params[:po][:budget_id] != "" && params[:budget][:name] != ""
                flash[:message] = "please add or assign ONE budget to PO!"
                redirect to '/purchase_order/new'
            else
                @po = PurchaseOrder.create(params[:po])
                if params[:po][:vendor_id] == ""
                    new_vendor = Vendor.create(params[:vendor])
                    @po.vendor = new_vendor
                elsif params[:po][:budget_id] == ""
                    new_budget = Budget.create(params[:budget])
                    @po.budget = new_budget
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

end