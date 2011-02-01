class ItemRequestsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @item = Item.find(params[:item_id])
    @item_request = ItemRequest.new(:item => @item)
    @item_request.requester = current_user.person
    @item_request.gifter    = @item_request.item.owner

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item_request }
    end
  end

  def show
  end
  
  def create
    @item_request           = ItemRequest.new(params[:item_request])
    @item_request.requester = current_user.person
    @item_request.gifter    = @item_request.item.owner
    @item_request.status    = ItemRequest::STATUS_REQUESTED

    respond_to do |format|
      if @item_request.save
        format.html { redirect_to(request_path(@item_request), :notice => 'Request was successfully created.') }
        format.xml  { render :xml => @item_request, :status => :created, :location => @item_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    render :text => "update"
  end  
end
