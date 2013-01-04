class ItemRequestsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_item_request, :only => [ :show, :accept, :reject, :cancel, :collected, :complete, :recall, :return, :acknowledge, :cancel_recall, :cancel_return, :returned ]
  before_filter :only_requester_or_gifter, :only => [ :cancel, :collected, :complete, :returned, :acknowledge ]
  before_filter :public_only_when_completed, :only => [:show]
  before_filter :only_gifter, :only => [ :accept, :reject, :recall, :cancel_recall ]
  before_filter :only_requester, :only => [:return, :cancel_return]
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
      if @item_request.completed? || @item_request.returned?
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

  def accept
    @item_request.accept!

    respond_to do |format|
      format.html { redirect_to_back }
      format.json do
        render :json => { :success => true,
                          :request_html  => item_request_html(@item_request),
                          :activity_html => last_activity_log_html_for(current_person) }
      end
    end


  end

  def reject
    @item_request.reject!

    respond_to do |format|
      format.html { redirect_to_back }
      format.json do
        render :json => { :success => true,
                          :request_html  => item_request_html(@item_request),
                          :activity_html => last_activity_log_html_for(current_person) }
      end
    end
  end

  def cancel
    @item_request.cancel!(current_user.person)

    respond_to do |format|
      format.html { redirect_to dashboard_path }
      format.json do
        render :json => { :success => true,
                          :request_html  => item_request_html(@item_request),
                          :activity_html => last_activity_log_html_for(current_person) }
      end
    end
  end

  def collected
    debugger
    @item_request.collected!

    respond_to do |format|
      if @item_request.item.purpose != Item::PURPOSE_GIFT
        item_request_box = ''
        item_request_box = item_request_html(@item_request) unless @item_request.shareage?
 
        format.html { redirect_to_back }
        format.json do
          render :json => { :success => true,
                            :share   => true,
                            :request_html  => item_request_box,
                            :activity_html => last_activity_log_html_for(current_person) }
        end
      else
        format.html {redirect_to new_request_feedback_path(@item_request)}
        format.json do
          people_helped_count  = current_person.reputation_rating.distinct_people_count.to_s
          gift_actions_count   = current_person.reputation_rating.gift_actions_count.to_s
          activity_level_count =current_person.reputation_rating.activity_level_count.to_s

          render :json => { :success => true,
                            :share   => 'false',
                            :request_html  => '',
                            :feedback => 'true',
                            :activity_html => last_activity_log_html_for(current_person),
                            :people_helped => people_helped_count,
                            :gift_actions => gift_actions_count,
                            :activity_level => activity_level_count }
        end
      end
    end
  end

  def complete
    @item_request.complete!(current_user.person)

    respond_to do |format|
      format.html { redirect_to new_request_feedback_path(@item_request) }
      format.json do
        people_helped_count  = current_person.reputation_rating.distinct_people_count.to_s
        gift_actions_count   = current_person.reputation_rating.gift_actions_count.to_s
        activity_level_count =current_person.reputation_rating.activity_level_count.to_s

        render :json => { :success => true,
                          :share   => 'false',
                          :request_html  => '',
                          :feedback => 'true',
                          :activity_html => last_activity_log_html_for(current_person),
                          :people_helped => people_helped_count,
                          :gift_actions => gift_actions_count,
                          :activity_level => activity_level_count }
      end
    end
  end

  def recall
    @item_request.recall!

    respond_to do |format|
      format.html { redirect_to_back }
      format.json do
        render :json => { :success => true,
                          :request_html  => item_request_html(@item_request),
                          :activity_html => last_activity_log_html_for(current_person) }
      end
    end


  end

  def return
    @item_request.return!

    respond_to do |format|
      format.html { redirect_to_back }
      format.json do
        render :json => { :success => true,
                          :request_html  => item_request_html(@item_request),
                          :activity_html => last_activity_log_html_for(current_person) }
      end
    end


  end

  def cancel_recall
    @item_request.cancel_recall!

    respond_to do |format|
      format.html { redirect_to_back }
      format.json do
        render :json => { :success => true,
                          :request_html  => '',
                          :activity_html => last_activity_log_html_for(current_person) }
      end
    end


  end

  def cancel_return
    @item_request.cancel_return!

    respond_to do |format|
      format.html { redirect_to_back }
      format.json do
        render :json => { :success => true,
													:request_html => '',
                          :activity_html => last_activity_log_html_for(current_person) }
      end
    end


  end

  def acknowledge
    @item_request.acknowledge!

    respond_to do |format|
      format.html { redirect_to_back }
      format.json do
        render :json => { :success => true,
                          :request_html  => item_request_html(@item_request),
                          :activity_html => last_activity_log_html_for(current_person) }
      end
    end


  end

  def returned
    @item_request.returned!

    respond_to do |format|
      format.html { redirect_to new_request_feedback_path(@item_request) }
      format.json do
        people_helped_count  = current_person.reputation_rating.distinct_people_count.to_s
        gift_actions_count   = current_person.reputation_rating.gift_actions_count.to_s
        activity_level_count =current_person.reputation_rating.activity_level_count.to_s

        render :json => { :success => true,
                          :share   => 'false',
                          :request_html  => '',
                          :activity_html => last_activity_log_html_for(current_person),
                          :people_helped => people_helped_count,
                          :gift_actions => gift_actions_count,
                          :activity_level => activity_level_count }
      end
    end
  end

  def new_comment
    model_name = params[:comment][:commentable_type]
    record_commentable = model_name.constantize.find(params[:comment][:commentable_id])
    record_commentable.leave_comment!(current_person)

    @comment = record_commentable.comments.create(:commentable => record_commentable,
                                                  :user_id     => current_user.id,
                                                  :comment     => params[:comment][:comment] )

    respond_to do |format|
      format.json do
        @comment_html = render_to_string(:partial => 'item_requests/comment.html.erb',
                                         :locals  => { :comment => @comment } )
        render :json => { :success => true, :comment_html => @comment_html  }
      end
    end
  end

  private

  def item_request_html(item_request)
    render_to_string(:partial => 'shared/item_request_content_box.html.erb',
                     :locals  => { :req => @item_request })
  end

  def last_activity_log_html_for(person)
    last_activity_log = person.activity_logs.last

    render_to_string(:partial => activity_log_partial,
                     :locals  => { :activity_log => last_activity_log })
  end

  def activity_log_partial
    if request.referer == dashboard_url
      'shared/activity_log_box.html.erb'
    else
      'shared/activity_log_box_for_profile.html.erb'
    end
  end

  def check_if_item_is_deleted
    item = Item.find_by_id(params[:item_id])

    if item.nil? or item.deleted?
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
      redirect_to(request_path(@item_request), :alert => I18n.t('messages.only_requester_can_access'))
    end
  end

  def public_only_when_completed
    unless @item_request.completed? || @item_request.gifter?(current_user.person) || @item_request.requester?(current_user.person)
      redirect_to(root_path, :alert => I18n.t('messages.only_gifter_and_requester_can_access'))
    end
  end
end
