class ItemRequestsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_item_request, :only => [ :show, :accept, :reject, :cancel, :collected, :complete ]
  before_filter :only_requester_or_gifter, :only => [ :show, :cancel, :collected, :complete ]
  before_filter :only_gifter, :only => [ :accept, :reject ]
  before_filter :check_if_item_is_deleted, :only => [:new, :create]

  def new
    @item = Item.find(params[:item_id])
    
    if @item.can_be_requested?    
      @item_request = ItemRequest.new(:item => @item)
      @item_request.requester = current_user.person
      @item_request.gifter    = @item_request.item.owner

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @item_request }
      end
    else
      redirect_to(item_path(@item), :notice => I18n.t('messages.item_requests.item_not_available_for_request'))
    end
  end

  def show
    @comments = @item_request.comments.sort { |a, b| b.created_at <=> a.created_at }

    respond_to do |format|
      if @item_request.completed?
        @commentable_object = EventLog.find_by_related_id_and_related_type(@item_request.id, "ItemRequest")
        @public_comments = @commentable_object.nil? ? [] : 
                           @commentable_object.comments.sort do |a, b| 
                              b.created_at <=> a.created_at
                            end 

        format.html { render 'completed'}
        format.xml  { render :xml => @item }
      else
        format.html # show.html.erb
        format.xml  { render :xml => @item }
      end
    end
  end
  
  def create
    if params[:item_id].nil?
      @item_request = ItemRequest.new_by_requester(params[:item_request], current_user.person)
    else
      @item = Item.find(params[:item_id])
      @item_request = ItemRequest.new(:requester=> current_user.person, :item_id => @item.id, :gifter=> @item.owner, :status => ItemRequest::STATUS_REQUESTED)
    end

    if @item_request.item.can_be_requested?
      respond_to do |format|
        if @item_request.save
          format.html { redirect_to(request_path(@item_request)) }
          format.xml  { render :xml => @item_request, :status => :created, :location => @item_request }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @item_request.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to(item_path(@item), :notice => I18n.t('messages.item_requests.item_not_available_for_request'))
    end
  end

  # TODO: create update method. Check if it's needed.
  def update
    render :text => "TODO update"
  end  
  
  def accept
    @item_request.accept!
    respond_to do |format|
      format.html { redirect_to_back }
      format.json do
        @user_html = render_to_string( :partial => 'shared/item_request_content_box.html.erb', :locals => {:req => @item_request } )
        acttivity = current_user.person.activity_logs.order("#{ActivityLog.table_name}.created_at DESC").limit(1)
        acttivity.each do |activity_log|
          @recent_activity = render_to_string( :partial => 'shared/activity_log_box.html.erb', :locals => { :activity_log => activity_log } )
        end
        render :json => { :success => true, :request_html => @user_html, :activity_html => @recent_activity  }
      end
    end
    
    
  end
  
  def reject
    @item_request.reject!

    respond_to do |format|
      format.html { redirect_to_back }

      format.json do
        @user_html = render_to_string(:partial  => 'shared/item_request_content_box.html.erb', 
                                      :locals   => { :req => @item_request })

        acttivity = current_user.person.activity_logs.
                    order("#{ActivityLog.table_name}.created_at DESC").limit(1)

        acttivity.each do |activity_log|
          @recent_activity = render_to_string(:partial => 'shared/activity_log_box.html.erb', 
                                              :locals => { :activity_log => activity_log })
        end

        render :json => { :success => true, 
                          :request_html  => @user_html, 
                          :activity_html => @recent_activity  }
      end
    end
  end
  
  def cancel
    @item_request.cancel!(current_user.person)
    respond_to do |format|
      format.html { redirect_to dashboard_path }
      format.json do
        @user_html = render_to_string( :partial => 'shared/item_request_content_box.html.erb', :locals => {:req => @item_request } )
        acttivity = current_user.person.activity_logs.order("#{ActivityLog.table_name}.created_at DESC").limit(1)
        acttivity.each do |activity_log|
          @recent_activity = render_to_string( :partial => 'shared/activity_log_box.html.erb', :locals => { :activity_log => activity_log } )
        end
        render :json => { :success => true, :request_html => @user_html, :activity_html => @recent_activity  }
      end
    end
  end
  
  def collected
    @item_request.collected!
    respond_to do |format|
      if @item_request.item.purpose != Item::PURPOSE_GIFT 
        format.html { redirect_to_back }
        format.json do
          @user_html = render_to_string( :partial => 'shared/item_request_content_box.html.erb', :locals => {:req => @item_request } )
          acttivity = current_user.person.activity_logs.order("#{ActivityLog.table_name}.created_at DESC").limit(1)
          acttivity.each do |activity_log|
            @recent_activity = render_to_string( :partial => 'shared/activity_log_box.html.erb', :locals => { :activity_log => activity_log } )
          end
          render :json => { :success => true, :request_html => @user_html, :activity_html => @recent_activity, :share => 'true'  }
        end
      else
        format.html {redirect_to new_request_feedback_path(@item_request)}
        format.json do
            acttivity = current_user.person.activity_logs.order("#{ActivityLog.table_name}.created_at DESC").limit(1)
            @user_html = ""
            acttivity.each do |activity_log|
              @recent_activity = render_to_string( :partial => 'shared/activity_log_box.html.erb', :locals => { :activity_log => activity_log } )
            end
            render :json => { :success => true, :people_helped => current_user.person.reputation_rating.distinct_people_count.to_s, 
                              :gift_actions => current_user.person.reputation_rating.gift_actions_count.to_s, 
                              :activity_level => current_user.person.reputation_rating.activity_level_count.to_s,  
                              :request_html => @user_html, :activity_html => @recent_activity, :share => 'false' }
        end
      end
      
    end
  end
  
  def complete
    @item_request.complete!(current_user.person)
    respond_to do |format|
      format.html { redirect_to new_request_feedback_path(@item_request) }
      format.json do
        acttivity = current_user.person.activity_logs.order("#{ActivityLog.table_name}.created_at DESC").limit(1)
        @user_html = ""
        acttivity.each do |activity_log|
          @recent_activity = render_to_string( :partial => 'shared/activity_log_box.html.erb', :locals => { :activity_log => activity_log } )
        end
        render :json => { :success => true, :people_helped => current_user.person.reputation_rating.distinct_people_count.to_s, 
                          :gift_actions => current_user.person.reputation_rating.gift_actions_count.to_s, 
                          :activity_level => current_user.person.reputation_rating.activity_level_count.to_s,  
                          :request_html => @user_html, :activity_html => @recent_activity }
      end
    end

  end
  
  private

  def check_if_item_is_deleted
    item = Item.find(params[:item_id]) if params[:item_id]

    if item and item.deleted?
      redirect_to items_path, :alert => (I18n.t('messages.items.is_deleted'))
    end
  end

  def get_item_request
    @item_request = ItemRequest.find(params[:id])
  end
  
  def only_requester_or_gifter
    unless @item_request.gifter?(current_user.person) || @item_request.requester?(current_user.person)
      redirect_to(root_path, :alert => I18n.t('messages.only_gifter_and_requester_can_access'))
    end    
  end
  
  def only_gifter
    unless @item_request.gifter? current_user.person
      redirect_to(request_path(@item_request), :alert => I18n.t('messages.only_gifter_can_access'))
    end
  end
  
  def only_requester
    unless @item_request.requester? current_user.person
      redirect_to(root_path, :alert => I18n.t('messages.only_requester_can_access'))
    end
  end
end
