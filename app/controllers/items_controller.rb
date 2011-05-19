class ItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_item, :only => [:show, :edit, :update, :destroy, :mark_as_normal, :mark_as_lost, :mark_as_damaged]
  before_filter :only_owner!, :only => [:edit, :update, :destroy, :mark_as_normal, :mark_as_lost, :mark_as_damaged]

  # GET /items
  # GET /items.xml
  def index
    if params[:search]
      @items = Item.search(params[:search], current_user.person.id)
    else
      @items = current_user.person.items.without_deleted
    end
    @trusted, @extended = [], []
    @items.each do |item|
      if item.in_trusted_network_for_person?(current_user.person)
        @trusted.push(item) 
      else
        @extended.push(item)
      end
    end

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
    @item.status = Item::STATUS_NORMAL
    @item.available = true

    respond_to do |format|
      if @item.save
        @item.create_new_item_event_log
        @item.create_new_item_activity_log
        current_user.person.reputation_rating.update_attributes(:activity_level => 1) if current_user.person.items.count == 1
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
    @item.delete

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml  { head :ok }
    end
  end

  def mark_as_normal
    @item.normal!
    redirect_to(item_path(@item), :notice => I18n.t('messages.items.marked_as_normal'))
  end

  def mark_as_lost
    @item.lost!
    redirect_to(item_path(@item), :notice => I18n.t('messages.items.marked_as_lost'))
  end

  def mark_as_damaged
    @item.damaged!
    redirect_to(item_path(@item), :notice => I18n.t('messages.items.marked_as_damaged'))
  end

  private
  def get_item
    @item = Item.find(params[:id])
  end
  
  def only_owner!
    redirect_to(root_path, :alert => I18n.t('messages.only_owner_can_access')) and return unless @item.is_owner?(current_user.person)
  end
  
end
