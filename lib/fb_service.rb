module FbService
  def self.fb_user_from(token)
    FbGraph::User.me(token)
  end

  def self.fb_friends_from(token)
    begin
      return fb_user_from(token).friends(options = {:access_token => token}) || []
    rescue
      puts "Access token was incorrect"
      return []
    end
  end

  def self.people_from_fb_friends(fb_friends)
    friends_identifiers = fb_friends.collect(&:identifier)
    Person.joins(:user).where('users.uid' => friends_identifiers)
  end

  def self.get_my_friends(token)
    friends_list = fb_friends_from(token)

    friends_list.empty? ? [] : people_from_fb_friends(friends_list).
                               authorized.
                               order(:name)
  end

  def self.search_fb_friends(token, search_term)
    search_term.empty? ? [] : get_my_friends(token).
                              where("UPPER(name) LIKE UPPER(?)", "%#{search_term}%")
  end

  def self.fb_logout_url(fb_api_key, fb_session_key, return_url)
    "http://www.facebook.com/logout.php" << 
    "?api_key=#{fb_api_key}" << 
    "&session_key=#{fb_session_key}" << 
    "&confirm=1&next=#{return_url}"
  end
end
