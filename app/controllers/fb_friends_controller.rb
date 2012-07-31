require 'fb_service'

class FbFriendsController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :check_facebook_session, :only => [:index, :search_fb_friends]

  def index
    if !(fb_user = current_person.facebook_user)
      return redirect_to :dashboard, :warning => "Facebook not connected"
    end

    @people  = FbService.get_my_friends(fb_user.token).order(:name)
    @villages = Village.all
  end

  def search_fb_friends
    fb_user = current_person.facebook_user
    if !fb_user
      return redirect_to :dashboard, :warning => "Facebook not connected"
    else
      search_terms = params[:search_terms] || ''
      @people = FbService.search_fb_friends(fb_user.token, search_terms)
      raise NotActivated if @people.nil?
      render :index
    end
  end

  def search_people
    @searching_people = true
    search_terms = params[:search_terms] || ''

    @people = Person.search(search_terms)
    @people = @people - [current_user.person] unless @people.empty?

    render :index
  end

  private
  
  def check_facebook_session
   user = FbGraph::User.new(:access_token => current_user.token)
   user.fetch
  end
end
