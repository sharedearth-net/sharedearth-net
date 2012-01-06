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

  def link_to_person(person, options = {})
    defaults = { :downcase_you => false, :possessive => false, :check_current_user => true, :no_link => false }
    options = defaults.merge(options)

		options[:class] ||= ""
		options[:class] += trusted_person_class(person)

    if options[:check_current_user] && person.user == current_user
      person_name = options[:possessive] ? "Your" : "You"
      person_name.downcase! if options[:downcase_you]
      options[:no_link] = true
    else
      person_name = person.name
      person_name = person_name.possessive if options[:possessive]
    end

    options[:no_link] ? person_name : link_to(person_name, person_path(person), options)
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

  def network_status_trusted_network(person = nil, only_path = true, link_options = {})
    person ||= current_person
    link_to pluralize(person.trusted_network_size, 'person') + " in your trusted network", network_person_path(person, :only_path => only_path), link_options
  end

  def network_status_personal_network(person = nil, only_path = true, link_options = {})
    person ||= current_person
    link_to pluralize(person.personal_network_size, 'person') + " in your entire network", my_network_person_path(person, :only_path => only_path), link_options
  end

  def network_status_items(person = nil)
    person ||= current_person
    pluralize(person.personal_network_items_count, 'item') + " available in your network"
  end

end
