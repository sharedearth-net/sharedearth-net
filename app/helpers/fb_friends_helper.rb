module FbFriendsHelper

  def trust_action_link_for(person)
    if person.requested_trusted_relationship?(current_person)
      text = "cancel trust request"
      href = people_network_request_path(person.requested_trusted_relationship(current_person))
      options = { :method => :delete }

    elsif current_person.trusts?(person)
      text = "withdraw trust"
      href = people_network_path(current_person.trusts?(person))
      options = { :method => :delete }

    elsif current_person.requested_trusted_relationship?(person)
      text = "confirm trust"
      href = confirm_people_network_request_path(
             current_person.requested_trusted_relationship(person))
      options = { :method => :put, :id => 'confirm_button' }

    else
      text = "acknowledge trust"
      href = people_network_requests_path(:trusted_person_id => person) 
      options = { :method => :post }
    end
    
    options[:remote] = true

    link_to(text, href, options)
  end
end
