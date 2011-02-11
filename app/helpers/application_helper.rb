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
    defaults = { :downcase_you => false }
    options = defaults.merge(options)
    name = (person.user == current_user ? "You" : person.name)
    name.downcase! if options[:downcase_you] && person.user == current_user
    name
  end
  
  def link_to_person(person, options = {})
    person.user == current_user ? person_name(person, options) : link_to(person_name(person, options), person_path(person))
  end
end
