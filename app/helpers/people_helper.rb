module PeopleHelper
 def mutual_friends
   params[:type] == 'mutual'
 end
 
 def all_friends
   params[:type] == 'all'
 end
 
 def other_friends
   params[:type] == 'other'
 end
 
 def extended_friends
   params[:type] == 'extended'
 end
 
 def in_network?(current_person, other_person )
   	if current_person.trusts?(other_person)
			image = image_tag("ic-trusted-net-you-green.png", :class => "icons", :alt => "Trusted Profile")
			link = link_to 'In your trusted network', (network_person_path(other_person))
	  else
			image = image_tag("ic-trusted-net-you-orange.png", :class => "icons", :alt => "Untrusted Profile") 
					if other_person.requested_trusted_relationship?(current_person)
						 link = "Establish trust request pending"
					else
					   link = link_to 'Not in your trusted network', (network_person_path(other_person)) 
					end
		end
		"#{image}<p>#{link}</p>".html_safe
 end
end
