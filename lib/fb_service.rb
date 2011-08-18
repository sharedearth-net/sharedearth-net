module FbService

# Returns a list of all my authorized fb friends Personas
  def self.get_my_friends(token)
    registered_user = FbGraph::User.me(token)
    friends_list = []

    begin
      fb_friends = registered_user.friends(options = {:access_token => token})  
    rescue
      puts "Access token was incorrect"
      return friends_list
    end

    unless fb_friends.nil?
      friends_identifiers = fb_friends.collect(&:identifier)

      user_list   = User.where(:uid => friends_identifiers)
      people_ids  = user_list.collect(&:person).delete_if { |p| p.nil? }.collect(&:id)
      friends_list = Person.authorized.where(:id => people_ids)
    end

    friends_list
  end

  def self.fb_logout_url(fb_api_key, fb_session_key, return_url)
    url = "http://www.facebook.com/logout.php"
    url << "?api_key=#{fb_api_key}"
    url << "&session_key=#{fb_session_key}"
    url << "&confirm=1&next=#{return_url}"
  end
end
