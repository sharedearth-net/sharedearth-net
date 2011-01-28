class ItemRequestsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @item_request = ItemRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def show
  end
  
  def create
    render :text => "create"
  end

  def update
    render :text => "update"
  end  
end
