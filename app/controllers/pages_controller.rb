class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :dashboard ]

  def index
    if current_user.nil? or current_user.person.nil?
      render
    elsif Settings.invitations == 'true' and not current_user.person.authorised? 
      render
    else
      redirect_to dashboard_path
    end
  end

  def dashboard
    @active_item_requests     = current_user.person.active_item_requests
    @people_network_requests  = current_user.person.received_people_network_requests + 
                                current_user.person.people_network_requests
    @requests = @active_item_requests + @people_network_requests

    @requests.sort! { |a,b| b.created_at <=> a.created_at }

    @recent_activity_logs = current_user.person.activity_logs.order("#{ActivityLog.table_name}.created_at DESC").limit(30) unless current_user.person.activity_logs.empty?

    current_user.person.news_feed
    @events = current_user.network_activity.paginate(:page => params[:page], :per_page => 25)
  end

  def about
    about_layout = (current_user.nil? ? 'shared_earth' : 'application')
    render :layout => about_layout
  end

  def no_javascript
    render :layout => 'welcome'
  end
end
