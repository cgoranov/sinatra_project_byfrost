
class VendorsController < ApplicationController

    get '/vendors' do
        redirect_if_not_loggedin
        @vendors = Vendor.all
        erb :'vendors/index'
    end

    get '/vendors/new' do
        redirect_if_not_loggedin
        erb :'vendors/new'
    end

    post '/vendors' do
        redirect_if_not_loggedin
        @new_vendor = Vendor.new(name: params[:name].downcase)
        if @new_vendor.valid?
            @new_vendor.save
            redirect to '/vendors'
        else
            @errors = @new_vendor.errors.messages.collect {|k, v| "#{k.to_s} #{v[0]}"}
            erb :'vendors/new'
        end
    end

    get '/vendors/:id/edit' do
        redirect_if_not_loggedin
        @vendor = Vendor.find_by(id: params[:id])
        erb :'vendors/edit'
    end

    patch '/vendors/:id' do 
        @vendor = Vendor.find_by(id: params[:id])
        @edit = Vendor.new(name: params[:vendor][:name])
        if @edit.valid?
            @vendor.update(name: params[:vendor][:name])
            redirect to '/vendors'
        else
            @errors = @edit.errors.messages.collect {|k, v| "#{k.to_s} #{v[0]}"}
            erb :'vendors/edit'
        end
    end

    delete '/vendors/:id' do
        redirect_if_not_loggedin
        @vendor = Vendor.find_by(id: params[:id])
        @vendor.destroy
        redirect to '/vendors'
    end
  
end