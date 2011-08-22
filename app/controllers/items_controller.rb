class ItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_item, :only => [:show, :edit, :update, :destroy, 
                                     :mark_as_normal, :mark_as_lost, :mark_as_damaged]
  before_filter :only_owner!, :only => [:edit, :update, :destroy,   
                                        :mark_as_normal, :mark_as_lost, :mark_as_damaged]
  before_filter :actions_completed?, :only => [:mark_as_lost, :mark_as_damaged]
  before_filter :check_if_item_is_deleted, :only => [:edit, :update, :destroy, 
                                                     :mark_as_normal, :mark_as_lost, 
                                                     :mark_as_damaged]
  before_filter :check_if_user_has_fb_account, :only => [:new, :create]
  def index
    @items = current_user.person.items.without_deleted

    respond_to do |format|
      format.html { render :action => 'search' if params[:search] }
      format.xml  { render :xml => @items }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def create
    @item = Item.new(params[:item])
    @item.owner = current_user.person
    @item.status = Item::STATUS_NORMAL
    @item.available = true

    respond_to do |format|
      if @item.save
        @item.create_new_item_event_log
        @item.create_new_item_activity_log

        if current_user.person.items.count == 1
          current_user.person.reputation_rating.update_attributes(:activity_level => 1)
        end

        post_new_item_on_fb(@item) if @item.post_it_on_fb == '1'

        format.html { redirect_to @item }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item }
        format.xml  { head :ok }
      else
      
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @item.delete

    respond_to do |format|
      format.html { redirect_to(items_path) }
      format.xml  { head :ok }
    end
  end

  def mark_as_normal
    @item.normal!
    redirect_to item_path(@item)
  end

  def mark_as_lost
    @item.lost!
    redirect_to item_path(@item)
  end

  def mark_as_damaged
    @item.damaged!
    redirect_to item_path(@item)
  end

  private

  def actions_completed?
    redirect_to item_path(@item), :notice => "Can't do that. Item is currently in use." unless @item.available?
  end
 
  def check_if_item_is_deleted
    if @item.deleted?
      redirect_to items_path, :alert => (I18n.t('messages.items.is_deleted'))
    end
  end

  def check_if_user_has_fb_account
    @can_post_to_fb = true if fb_token
  end

  def get_item
    @item = Item.find_by_id(params[:id])
  end
  
  def only_owner!
    redirect_to(root_path, :alert => I18n.t('messages.only_owner_can_access')) and return unless @item.is_owner?(current_user.person)
  end

  def post_new_item_on_fb(item)
    msg  = "is now sharing their #{item.item_type.downcase} on sharedearth.net."
    link = item_url(item)

    FbService.post_on_my_wall(fb_token, msg, link, :append_name => true)
  end
end
