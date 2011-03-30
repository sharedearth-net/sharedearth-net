module PagesHelper

  def recent_activity_sentance(activity_log)
  
    gifter              = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive"
    gifter_possesive    = link_to activity_log.secondary_short_name.possessive, person_path(activity_log.secondary), :class => "positive"
    person              = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive"
    person_possesive    = link_to activity_log.secondary_short_name.possessive, person_path(activity_log.secondary), :class => "positive"
    person_full         = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive"
    
    requester           = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive"
    requester_possesive = link_to activity_log.secondary_short_name.possessive, person_path(activity_log.secondary), :class => "positive"
    item                = link_to activity_log.action_object_type_readable, item_path(activity_log.action_object), :class => "positive"
    
    sentance = ""
    case activity_log.event_type_id
    when 1
      sentance = "You are now sharing your " + item 
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
      
      
      
    when 18
      sentance =  ""
    when 19
      sentance =  "You are now sharing your " + item
    when 20
      sentance =  ""
    when 21
      sentance =  ""
    when 22
      sentance =  ""
    when 23
      sentance =  ""
    when 24
      sentance =  "Your " + item + " is damaged!" #this is duplicate of - 51
    when 25
      sentance =  "Your " + item + " is repaired!" #this is duplicate of - 52
    when 26
      sentance =  ""

      
      
    when 27
      sentance =  "You accepted " + person_possesive + " request for your " + item
    when 28
      sentance =  "You rejected " + person_possesive + " request for your " + item
    when 29
      sentance =  person + " accepted your request for their " + item
    when 30
      sentance =  person + " rejected your request for their " +  item
    when 31
      sentance =  person + " completed the action of receiving your " + item
    when 32
      sentance =  "You completed the action of receiving " + person_possesive + " " + item
    when 33
      sentance =  "You completed the action of gifting your " + item + " to " + person
    when 34
      sentance =  person + " completed the action of gifting their " + item + " to you"
    when 35
      sentance =  "You canceled the action of gifting your " + item + " to " + person 
    when 36
      sentance =  person + " canceled the action of gifting their " + item + " to you"
    when 37
      sentance =  person + " canceled the request for your " + item
    when 38
      sentance =  "You cancelled the request for " + person_possesive + " " + item 
      
    
    
    when 39
      sentance =  person + " made a request to borrow your " + item  #this is duplicate of  - 2, not used at this moment, left for possible future use
    when 40
      sentance =  "You made a request to borrow " + person_possesive + " " + item  #this is duplicate of - 3, not used at this moment, left for possible future use
    when 41
      sentance =  person + " confirmed you have a trusted relationship with them"
    when 42
      sentance =  "You confirmed you have a trusted relationship with " + person
    when 43
      sentance =  person + " denied you have a trusted relationship with them"
    when 44
      sentance =  "You denied you have a trusted relationship with " + person
    when 45
      sentance =  "You have withdrawn your trust for " + person
    when 46
      sentance =  person + " has withdrawn their trust for you"
    when 47
      sentance =  "You cancelled the establishment of a trusted relationship with " + person
    when 48
      sentance =  person + " cancelled the establishment of a trusted relationship with you"
    when 49
      sentance =  "You lost your " + item + "!"
    when 50
      sentance =  "You found your " + item + "!"
    when 51
      sentance =  "Your " + item + "is damaged!"    #this is duplicate of - when 24
    when 52
      sentance =  "Your " + item + " is repaired!"  #this is duplicate of - when 25
    when 53
      sentance =  "You removed your " + item + " from sharedearth.net"
    when 54
      sentance =  "You connected to sharedearth.net"
    when 55
      sentance =  person + " has left you positive feedback after borrowing your " + item
    when 56
      sentance =  person + " has left you positive feedback after sharing their " + item + " with you"
    when 57
      sentance =  person + " has left you negative feedback after borrowing your " + item
    when 58
      sentance =  person + " has left you negative feedback after sharing their " + item + " with you"
    when 59
      sentance =  person + " has left you neutral feedback after borrowing your " + item
    when 60
      sentance =  person + " has left you neutral feedback after sharing their " + item + " with you"
     
      
    else
      #
    end
    
    sentance.html_safe
     
  end
end
