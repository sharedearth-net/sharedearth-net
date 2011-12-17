module ApplicationHelper
  def owner_only(item, &block)
    capture(&block) if current_user && item.is_owner?(current_user.person)
  end

  def gifter_only(item_request, &block)
    capture(&block) if current_user && item_request.gifter?(current_user.person)
  end

  def requester_only(item_request, &block)
    capture(&block) if current_user && item_request.requester?(current_user.person)
  end

  def requester_and_gifter_only(item_request, &block)
    capture(&block) if current_user && (item_request.gifter?(current_user.person) || item_request.requester?(current_user.person))
  end
  
  def person_name(person, options = {})
    defaults = { :downcase_you => false, :possessive => false }
    options = defaults.merge(options)
    
    if person.user == current_user
      name = options[:possessive] ? "Your" : "You"
      name.downcase! if options[:downcase_you]
    else
      name = person.name
      name = name.possessive if options[:possessive]
    end
    name
  end
  
  def link_to_person(person, options = {})
		options[:class] ||= ""
		options[:class] += trusted_person_class(person)
    person.user == current_user ? person_name(person, options) : link_to(person_name(person, options), person_path(person), options)
  end

  # Returns photo URL of either item being requested or the other user involved in request
  def item_request_photo(item_request, options = {})
    defaults = { :size => :medium }
    options = defaults.merge(options)

    if item_request.item.photo?
      item_request.item.photo.url(options[:size])
    elsif item_request.requester?(current_user.person)
      item_request.gifter.avatar(options[:size])
    else
      item_request.requester.avatar(options[:size])
    end
  end

  # Returns photo URL of the other user involved in request
  def people_network_request_photo(people_network_request, options = {})
    defaults = { :size => :medium }
    options = defaults.merge(options)

    if people_network_request.requester?(current_user.person)
      people_network_request.trusted_person.avatar(options[:size])
    else
      people_network_request.person.avatar(options[:size])
    end
  end
end
