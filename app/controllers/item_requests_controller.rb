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
    @item_request = ItemRequest.find(params[:id])
    
    # only gifter or requester can access
    unless @item_request.gifter == current_user.person || @item_request.requester == current_user.person
      redirect_to(root_path, :alert => I18n.t('messages.only_gifter_and_requester_can_access')) and return 
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
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
