class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :dashboard ]

  def index
  end

  def dashboard
    @all_item_requests = current_user.person.all_item_requests
  end
end
