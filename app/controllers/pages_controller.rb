class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :dashboard ]

  def index
  end

  def dashboard
    @active_item_requests = current_user.person.active_item_requests
    @people_network_requests = current_user.person.received_people_network_requests + current_user.person.people_network_requests
    @requests = @active_item_requests + @people_network_requests
    @requests.sort! { |a,b| b.created_at <=> a.created_at }
  end
end
