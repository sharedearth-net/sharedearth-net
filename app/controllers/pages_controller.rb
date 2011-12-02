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

    unless current_user.person.activity_logs.empty?
      @recent_activity_logs = current_user.person.recent_activity_logs
		end
    current_user.person.reset_notification_count!
    current_user.record_last_activity!
    current_user.person.news_feed
    @events = current_user.network_activity.paginate(:page => params[:page], :per_page => 25)
  end

  def about
    about_layout = ((current_user.nil?  || !current_user.person.authorised_account || !current_user.person.accepted_pp?) ? 'shared_earth' : 'application')
    render :layout => about_layout
  end

  def contribute
    contribute_layout = ((current_user.nil?  || !current_user.person.authorised_account || !current_user.person.accepted_pp?) ? 'shared_earth' : 'application')
    render :layout => contribute_layout
  end

  def no_javascript
    render :layout => 'welcome'
  end
  
  def collect_email
		render :layout => nil
  end
end
