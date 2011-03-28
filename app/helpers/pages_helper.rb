module PagesHelper

  def recent_activity_sentance(activity_log)
  
    gifter              = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive"
    gifter_possesive    = link_to activity_log.secondary_short_name.possessive, person_path(activity_log.secondary), :class => "positive"
    requester           = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive"
    requester_possesive = link_to activity_log.secondary_short_name.possessive, person_path(activity_log.secondary), :class => "positive"
    item                = link_to activity_log.action_object_type_readable, item_path(activity_log.action_object), :class => "positive"
    
    sentance = ""
    case activity_log.event_type_id
    when 1
      sentance = " You are now sharing your " + item
    when 2
      sentance = requester + " made a request to borrow your " + item
    when 3
      sentance =  "You made a request to borrow " + gifter_possesive +  " " +  item
    when 4
      sentance = "You accepted " + requester_possesive + " request to borrow your " +  item
    when 5
      sentance = "You rejected " + requester_possesive + " request to borrow your " +  item
    when 6
      sentance = gifter + " accepted your request to borrow their " + item
    when 7
      sentance = gifter + " rejected your request to borrow their " + item
    when 8
      sentance = requester + " collected your " + item
    when 9
      sentance =  "You collected " + gifter_possesive + " " +  item
    when 10
      sentance =  requester + " completed the action borrowing your " + item
    when 11
      sentance =  "You completed the action of borrowing " + gifter_possesive + " " + item
    when 12
      sentance =  "You completed the action of sharing your " + item + " with " + requester
    when 13
      sentance =  gifter + " completed the action sharing their " + item + " with you "
    when 14
      sentance =  "You canceled the action sharing your " +  item + " with " + requester
    when 15
      sentance =  gifter + " canceled the action sharing their " + item + " with you "
    when 16
      sentance =  requester + " canceled the request to borrow your " + item
    when 17
      sentance =  "You canceled the request to borrow " + gifter_possesive + " " + item
    else
      #
    end
    
    sentance.html_safe
     
  end
end
