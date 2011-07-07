class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :dashboard ]

  def index
    redirect_to dashboard_path unless current_user.nil?
  end

  def dashboard
    @active_item_requests = current_user.person.active_item_requests
    @people_network_requests = current_user.person.received_people_network_requests + current_user.person.people_network_requests
    @requests = @active_item_requests + @people_network_requests
    @requests.sort! { |a,b| b.created_at <=> a.created_at }
    
    @recent_activity_logs = current_user.person.activity_logs.order("#{ActivityLog.table_name}.created_at DESC").limit(30) unless current_user.person.activity_logs.empty?
    event_logs = current_user.person.news_feed
    @events = EventDisplay.paginate(:page => params[:page], :per_page => 25, :conditions => [ 'person_id=?', current_user.person.id ], 
                                                                             :order => 'created_at DESC', :include => [:event_log])
   end

end
