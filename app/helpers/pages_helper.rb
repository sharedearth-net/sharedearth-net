module PagesHelper

  def recent_activity_sentance(activity_log)
  
    gifter              = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive"
    gifter_possesive    = link_to activity_log.secondary_short_name.possessive, person_path(activity_log.secondary), :class => "positive"
    requester           = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive"
    requester_possesive = link_to activity_log.secondary_short_name.possessive, person_path(activity_log.secondary), :class => "positive"
    item                = link_to activity_log.action_object_type_readable, item_path(activity_log.action_object), :class => "positive"
    event_type          = EventType.find(activity_log.event_type_id).name
    
    sentance = ""
    case event_type
    when EventType.find(1).name
      sentance = requester + " requested your " + item
    when EventType.find(2).name
      sentance = requester + " requested your " + item
    when EventType.find(3).name
      sentance =  "You requested " + requester_possesive +  " " +  item
    when EventType.find(4).name
      sentance = "You accepted " + requester_possesive + " request to share your " +  item
    when EventType.find(5).name
      sentance = "You rejected " + requester_possesive + " request to share your " +  item
    when EventType.find(6).name
      sentance = requester + " accepted your request to share their " + item + " with you"
    when EventType.find(7).name
      sentance = gifter + " rejected your request to share their " + item
    when EventType.find(8).name
      sentance = requester + " collected your " + item
    when EventType.find(9).name
      sentance =  "You collected " + gifter_possesive + " " +  item
    when EventType.find(10).name
      sentance =  requester + " completed the action sharing your " + item
    when EventType.find(11).name
      sentance =  "You completed the action sharing " + gifter_possesive + " " + item
    when EventType.find(12).name
      sentance =  "You completed the action sharing your " + link_to_item + " with " + gifter_possesive
    when EventType.find(13).name
      sentance =  gifter_possesive + " completed the action sharing their " + item + " with you "
    when EventType.find(14).name
      sentance =  "You canceled the action sharing your " +  item + " with " + requester
    when EventType.find(15).name
      sentance =  gifter_possesive + " canceled the action sharing their " + item + " with you "
    when EventType.find(16).name
      sentance =  requester + " canceled the request for your " + item
    when EventType.find(17).name
      sentance =  "You canceled the request for your " + item
    else
      #
    end
    
    sentance.html_safe
     
  end
end
