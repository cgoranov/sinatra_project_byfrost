
class VendorsController < ApplicationController

    get '/vendors/new' do
        redirect_if_not_loggedin
        erb :'vendors/new'
    end

    

    
end