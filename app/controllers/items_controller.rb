class ItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_item, :only => [:show, :edit, :update, :destroy]
  before_filter :only_owner!, :only => [:edit, :update, :destroy]#:except => [:index, :new, :create]

  # GET /items
  # GET /items.xml
  def index
    @items = current_user.person.items

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(params[:item])
    @item.owner = current_user.person

    respond_to do |format|
      if @item.save
        format.html { redirect_to(@item, :notice => 'Item was successfully created.') }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to(@item, :notice => 'Item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml  { head :ok }
    end
  end

  private
  def get_item
    @item = Item.find(params[:id])
  end
  
  def only_owner!
    redirect_to(root_path, :alert => I18n.t('messages.only_owner_can_access')) and return unless @item.is_owner?(current_user.person)
  end
end
