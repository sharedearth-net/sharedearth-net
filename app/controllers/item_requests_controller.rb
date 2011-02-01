class ItemRequestsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @item = Item.find(params[:item_id])
    @item_request = ItemRequest.new(:item => @item)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def show
  end
  
  def create
    # @item = Item.new(params[:item])
    # @item.owner = current_user.person
    # 
    # respond_to do |format|
    #   if @item.save
    #     format.html { redirect_to(@item, :notice => 'Item was successfully created.') }
    #     format.xml  { render :xml => @item, :status => :created, :location => @item }
    #   else
    #     format.html { render :action => "new" }
    #     format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
    #   end
    # end
    render :text => "create"
  end

  def update
    render :text => "update"
  end  
end
