require 'fb_service'

class FbFriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    fb_token = session[:fb_token]
    @people  = FbService.get_my_friends(fb_token)
  end

  def search
    fb_token     = session[:fb_token]
    search_terms = params[:search_terms] || ''

    all_friends = FbService.get_my_friends(fb_token)

    @people = all_friends.delete_if do |friend|
      !friend.name.upcase.match search_terms.upcase
    end

    render :index
  end
end
