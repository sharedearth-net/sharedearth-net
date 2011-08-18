require 'fb_service'

class FbFriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    fb_token = session[:fb_token]

    @people  = FbService.get_my_friends(fb_token)
  end

  def search_fb_friends
    fb_token     = session[:fb_token]
    search_terms = params[:search_terms] || ''

    @people = FbService.search_fb_friends(fb_token, search_terms)

    render :index
  end

  def search_people
    @searching_people = true
    search_terms = params[:search_terms] || ''

    @people = Person.search(search_terms)
    @people = @people - [current_user.person] unless @people.empty?

    render :index
  end
end
