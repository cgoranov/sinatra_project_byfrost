
class PurchaseOrdersController < ApplicationController
    
    get '/purchase_order/new' do
        if logged_in?
            erb :'purchase_orders/new_po'
        else
            redirect to '/user/login'
        end
    end

    post '/purchase_order' do
        binding.pry
       if valid_number?(params[:po_number]) && valid_number?(params[:po_authorized_amout]) 
            @po = PurchaseOrder.create()
       end
    end

end