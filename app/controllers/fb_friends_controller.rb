require 'fb_service'

class FbFriendsController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :check_facebook_session, :only => [:index, :search_fb_friends]

  def index
    fb_token = session[:fb_token]
    @people  = FbService.get_my_friends(fb_token).order(:name)
  end

  def search_fb_friends
    fb_token     = session[:fb_token]
    search_terms = params[:search_terms] || ''

    @people = FbService.search_fb_friends(fb_token, search_terms)
    raise NotActivated if @people.nil?
    render :index
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
