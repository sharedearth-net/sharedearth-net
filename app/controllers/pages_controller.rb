class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :dashboard ]

  def index
  end

  def dashboard
    @active_item_requests = current_user.person.active_item_requests
    @people_network_requests = current_user.person.received_people_network_requests + current_user.person.people_network_requests
    @requests = @active_item_requests + @people_network_requests
    @requests.sort! { |a,b| b.created_at <=> a.created_at }
    
    @recent_activity_logs = current_user.person.activity_logs.order("#{ActivityLog.table_name}.created_at DESC").limit(30)
    @event_logs = current_user.person.news_feed
    @news_feed_cashe = current_user.person.news_feed_cashe(@event_logs) if !@event_logs.nil?
   end
end
