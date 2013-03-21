module FbFriendsHelper

  def trust_action_link_for(person)
    if person.requested_trusted_relationship?(current_person)
      text = "cancel trust request"
      href = network_request_path(person.requested_trusted_relationship(current_person))
      options = { :method => :delete }

    elsif current_person.trusts?(person)
      text = "withdraw trust"
      href = human_network_path(current_person.trusts?(person))
      options = { :method => :delete }

    elsif current_person.requested_trusted_relationship?(person)
      text = "confirm trust"
      # href = confirm_human_network_request_path(
      #        current_person.requested_trusted_relationship(person))
      options = { :method => :put, :id => 'confirm_button' }

    else
      text = "trust"
      href = network_requests_path(:trusted_person_id => person) 
      options = { :method => :post }
    end
    
    options[:remote] = true

    link_to(text, href, options)
  end

  def get_count_trusted_network_person_ids (person, village)
    HumanNetwork.trusted_network_person_ids_count(person, village)
  end

  def get_count_people_from_community(person, village)
    HumanNetwork.people_from_community_count(person, village)
  end

  def get_count_people_live_in(village)
    HumanNetwork.village_members(village).count
  end

  def get_count_entity_items(village)
     ResourceNetwork.group_items(village).count
  end
  
end
