class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :dashboard ]

  def index
  end

  def dashboard
    @active_item_requests = current_user.person.active_item_requests
  end
end
