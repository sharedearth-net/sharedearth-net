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
end
