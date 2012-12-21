module ApplicationHelper  
  def link_to_person(person, options = {})
    defaults = { :downcase_you => false, :possessive => false, :check_current_user => true, :no_link => false }
    options = defaults.merge(options)

		options[:class] ||= ""
		options[:class] += trusted_person_class(person)

    if options[:check_current_user] && current_user.person == person
      person_name = options[:possessive] ? "Your" : "You"
      person_name.downcase! if options[:downcase_you]
      options[:no_link] = true
    else
      person_name = person.name
      person_name = person_name.possessive if options[:possessive]
    end

    options[:no_link] ? person_name : link_to(person_name, person_path(person), options)
  end

  # Returns photo URL of the other user involved in request
  def network_request_photo(network_request, options = {})
    defaults = { :size => :medium }
    options = defaults.merge(options)

    if network_request.requester?(current_user.person)
      network_request.trusted_person.avatar(options[:size])
    else
      network_request.person.avatar(options[:size])
    end
  end

  def network_status_trusted_network(person = nil, only_path = true, link_options = {})
    person ||= current_person
    link_to pluralize(person.trusted_network_size, 'person') + " in your trusted network", network_person_path(person, :only_path => only_path), link_options
  end

  #N: Check this method

  def network_status_personal_network(person = nil, only_path = true, link_options = {})
    person ||= current_person
    link_to pluralize(person.personal_network_size, 'person') + " in my community", my_network_person_path(person, :only_path => only_path), link_options
  end

  def network_status_items(person = nil)
    person ||= current_person
    pluralize(person.personal_network_items_count, 'item') + " available"
  end

  def need_gcf_check
    ua = request.env['HTTP_USER_AGENT']
    if ua =~ /MSIE/ && !( ua =~ /chromeframe/ )
      return true
    end
    false
  end
  
  def indefiniteArticles(word)
    if word.end_with?("s")
      return "" 
    elsif word.start_with?("a","e","i","o","u")
      return "an"
    else 
      return "a"
    end 
  end

  def authorized_persons_count
    #caching
    
    Rails.cache.fetch "authorized_persons_count",:expires_in  => 12.hours do
      puts "people"
       Person.authorized.count.to_s
      #Rails.cache.write("authorized_persons_count",value)      
    end
    #value
  end

  def resources_shared_count
    #caching
    Rails.cache.fetch "resources_shared_count", :expires_in  => 12.hours do  
      puts "resources"    
     ResourceNetwork.all.count.to_s
    end
  end
  def gift_actions_count
    #caching
    Rails.cache.fetch "gift_actions_count", :expires_in  => 12.hours do    
      puts "gift"        
      ActivityLog.all_gift_actions.count.to_s
    end
  end
  
end
