module PagesHelper
  #USE SAME METHOD TO DISPLAY MY EVENTS TO ME, AND MY EVENTS TO OTHER PERSON - SECOND PARAMETER INDICATES IF IT IS SHOWN TO OTHER PERSON IF NOT NIL
  def event_log_sentence(event_log, person, feed)
   
    
    @same_person = (person.nil? || (current_user.person == person)) ? true : false
    person||= current_user.person
    (feed == EventDisplay::RECENT_ACTIVITY_FEED) ? text_class = "positive normal" : text_class = ""
   
    @item                = link_to event_log.action_object_type_readable, item_path(event_log.action_object_id), :class => text_class unless event_log.action_object_type_readable.nil?
    @requester           = link_to event_log.primary_short_name, person_path(event_log.primary), :class => text_class unless event_log.primary_short_name.nil?
  	@requester_possesive = link_to event_log.primary_short_name.possessive, person_path(event_log.primary), :class => text_class unless event_log.primary_short_name.nil?
  	@gifter              = link_to event_log.secondary_short_name, person_path(event_log.secondary), :class => text_class unless event_log.secondary_short_name.nil?
  	@gifter_possesive    = link_to event_log.secondary_short_name.possessive, person_path(event_log.secondary), :class => text_class unless event_log.secondary_short_name.nil?
  	 
	  @first_person       = link_to event_log.primary_short_name, person_path(event_log.primary), :class => text_class unless event_log.primary_short_name.nil?
    @first_person_full  = link_to event_log.primary_full_name, person_path(event_log.primary), :class => text_class unless event_log.primary_full_name.nil?
    @second_person      = link_to event_log.secondary_short_name, person_path(event_log.secondary), :class => text_class unless event_log.secondary_short_name.nil?
    @second_person_full = link_to event_log.secondary_full_name, person_path(event_log.secondary), :class => text_class unless event_log.secondary_full_name.nil?

    case event_log.event_type.id
    when 18
      sharing_sentence(event_log, person)
    when 19
      add_item_sentence(event_log, person)
    when 20
      negative_feedback_sentence(event_log, person)
    when 21
      gifting_sentence(event_log, person)
    when 22
      trust_established_sentence(event_log, person)
    when 23
      trust_withdrawn_sentence(event_log, person)
    when 24
      item_damaged_sentence(event_log, person)
    when 25
      item_repaired_sentence(event_log, person)
    when 26
      fb_friend_join_sentence(event_log, person)
    else
      #
    end

  end
  
  def add_item_sentence(event_log, person)
   
    if event_log.involved_as_requester?(person)
       if @same_person
         sentence = "You are now sharing your" + " " + @item
       else
         sentence = event_log.primary_short_name + " " + "is now sharing their" + " " + @item
       end
      
    else
      sentence = @requester + " " + "is now sharing their" + " " + @item
    end
    sentence.html_safe
  end
  
  def sharing_sentence(event_log, person)
  
   if event_log.involved_as_requester?(person)
     if @same_person
       sentence = "You borrowed " + @gifter_possesive + " " + @item
     else
       sentence = event_log.primary_short_name + " borrowed " + @gifter_possesive + " " + @item
     end
   elsif event_log.involved_as_gifter?(person)
     if @same_person
       sentence = @requester + " borrowed your " + @item
     else
       sentence = event_log.secondary_short_name + " shared their " + @item + " with " + @requester
     end
   elsif person.trusts?(event_log.primary) && !person.trusts?(event_log.secondary)
     sentence = @requester + " borrowed " + @gifter_possesive + " " + @item
	 elsif !person.trusts?(event_log.primary) && person.trusts?(event_log.secondary)
     sentence = @gifter + " shared their " + @item + " with " + @requester
	 elsif person.trusts?(event_log.primary) && person.trusts?(event_log.secondary)
      sentence = @gifter + " " + "shared their" + " " + @item + " with " + @requester 
   else
     sentence = ""
   end
   
   sentence.html_safe
  end
  
  def gifting_sentence(event_log, person)
  
   if event_log.involved_as_requester?(person)
     if @same_person
       sentence = "You received " + @gifter_possesive + " " + @item
     else
       sentence = event_log.primary_short_name + " received " + @gifter_possesive + " " + @item
     end
   elsif event_log.involved_as_gifter?(person)
     if @same_person
       sentence = "You gifted your " + @item + " to " +  @requester
     else
       sentence = event_log.secondary_short_name + " gifted their " + @item + " to " +  @requester
     end
   elsif person.trusts?(event_log.primary) && !person.trusts?(event_log.secondary)
     sentence = @requester + " received " + @gifter_possesive + " " + @item
	 elsif person.trusts?(event_log.primary) && person.trusts?(event_log.secondary)
     sentence = @gifter + " gifted their " + @item + " to " + @requester
	 elsif person.trusts?(event_log.primary) && person.trusts?(event_log.secondary)
      sentence = @gifter + " gifted their " + @item + " to " + @requester 
   else
     sentence = ""
   end
   
   sentence.html_safe
  end
  
  def trust_established_sentence(event_log, person)

    if event_log.involved_as_requester?(person)
      if @same_person
         sentence = "You have established a trusted relationship with " + @second_person
       else
         sentence = event_log.primary_short_name + " has established a trusted relationship with " + @second_person
      end
    elsif event_log.involved_as_gifter?(person)
      if @same_person
         sentence = "You have established a trusted relationship with " + @first_person
      else
         sentence = event_log.primary_short_name + " has established a trusted relationship with " + @first_person
      end
    elsif person.trusts?(event_log.primary)
      sentence = @first_person + " has established a trusted relationship with " + @second_person_full
    elsif person.trusts?(event_log.secondary)
      sentence = @second_person + " has established a trusted relationship with " + @first_person_full
    elsif person.trusts?(event_log.primary) && person.trusts?(event_log.secondary)
      sentence = @first_person + " and " + @second_person + " have established a trusted relationship"
    else 
      sentence = ""
    end

    sentence.html_safe
  end

  def trust_withdrawn_sentence(event_log, person)
    if event_log.involved_as_requester?(person)
      if @same_person
         sentence = "You have withdrawn your trust for " + @second_person
       else
         sentence = event_log.primary_short_name +  " has withdrawn their trust for " + @second_person_full
      end
    elsif event_log.involved_as_gifter?(person)
      if @same_person
         sentence = @first_person + " has withdrawn their trust for you"
      else
         sentence = @first_person + " has withdrawn their trust for " + event_log.secondary_short_name
      end
    elsif person.trusts?(event_log.primary)
      sentence = @first_person + " has withdrawn their trust for " + @second_person_full
    elsif person.trusts?(event_log.secondary)
      sentence = @second_person + " has withdrawn their trust for " + @first_person_full
    elsif person.trusts?(event_log.primary) && person.trusts?(event_log.secondary)
      sentence = @first_person + " has withdrawn their trust for " + @second_person
    else
      sentence = ""
    end
    
    sentence.html_safe
  end
  
  def item_damaged_sentence(event_log, person)
    if event_log.action_object.is_owner?(person)
       if @same_person
         sentence = "Your " + " " + @item + " " + "is broken"
       else
         sentence = event_log.primary_short_name.possessive + " " + @item + " " + "is broken"
       end
    else
      sentence = @requester_possesive + " " + @item + " " + "is broken"
    end
    sentence.html_safe
  end
  
  def item_repaired_sentence(event_log, person)
    if event_log.action_object.is_owner?(person)
       if @same_person
         sentence = "Your " + " " + @item + " " + "has been repaired"
       else
         sentence = event_log.primary_short_name.possessive + " " + @item + " " + "has been repaired"
       end
    else
      sentence = @requester_possesive + " " + @item + " " + "has been repaired"
    end
    sentence.html_safe
  end
  
  def fb_friend_join_sentence(event_log, person)
    sentence = @first_person_full + " has connected to sharedearth.net " 
    sentence.html_safe 
  end
  
  def recent_activity_avatar(activity_log)
    current_person = current_user.person
    if current_person != activity_log.secondary
      person = activity_log.secondary
    else
      person = activity_log.primary
    end
    
    case activity_log.event_type_id
    when 1
      current_person
    when 2
      person
    when 3
      current_person
    when 4
      current_person
    when 5
      current_person
    when 6
      person
    when 7
      person
    when 8
      person
    when 9
      current_person
    when 10
      person
    when 11
      current_person
    when 12
      current_person
    when 13
      person
    when 14
      current_person
    when 15
      person
    when 16
      person
    when 17
      current_person
       
      
    when 27
      current_person
    when 28
      current_person
    when 29
      person
    when 30
      person
    when 31
      person
    when 32
      current_person
    when 33
      current_person
    when 34
      person
    when 35
      current_person
    when 36
      person
    when 37
      person
    when 38
      current_person
    else
      current_person
    end
    
  end
  

  def recent_activity_sentence(activity_log)
  
    gifter              = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive" unless activity_log.secondary_short_name.nil?
    gifter_possesive    = link_to activity_log.secondary_short_name.possessive, person_path(activity_log.secondary), :class => "positive" unless activity_log.secondary_short_name.nil?
    person              = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive"
    person_possesive    = link_to activity_log.secondary_short_name.possessive, person_path(activity_log.secondary), :class => "positive "unless activity_log.secondary_short_name.nil?
    person_full         = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive" unless activity_log.secondary_short_name.nil?
    
    requester           = link_to activity_log.secondary_short_name, person_path(activity_log.secondary), :class => "positive" unless activity_log.secondary_short_name.nil?
    requester_possesive = link_to activity_log.secondary_short_name.possessive, person_path(activity_log.secondary), :class => "positive" unless activity_log.secondary_short_name.nil?
    item                = link_to activity_log.action_object_type_readable, item_path(activity_log.action_object), :class => "positive normal"
    
    sentence = ""
    case activity_log.event_type_id
    when 1
      sentence = "You are now sharing your " + item 
    when 2
      sentence = requester + " made a request to borrow your " + item
    when 3
      sentence =  "You made a request to borrow " + gifter_possesive +  " " +  item
    when 4
      sentence = "You accepted " + requester_possesive + " request to borrow your " +  item
    when 5
      sentence = "You rejected " + requester_possesive + " request to borrow your " +  item
    when 6
      sentence = gifter + " accepted your request to borrow their " + item
    when 7
      sentence = gifter + " rejected your request to borrow their " + item
    when 8
      sentence = requester + " collected your " + item
    when 9
      sentence =  "You collected " + gifter_possesive + " " +  item
    when 10
      sentence =  requester + " completed the action borrowing your " + item
    when 11
      sentence =  "You completed the action of borrowing " + gifter_possesive + " " + item
    when 12
      sentence =  "You completed the action of sharing your " + item + " with " + requester
    when 13
      sentence =  gifter + " completed the action sharing their " + item + " with you "
    when 14
      sentence =  "You canceled the action sharing your " +  item + " with " + requester
    when 15
      sentence =  gifter + " canceled the action sharing their " + item + " with you "
    when 16
      sentence =  requester + " canceled the request to borrow your " + item
    when 17
      sentence =  "You canceled the request to borrow " + gifter_possesive + " " + item
      
      
      
    when 18
      sentence =  ""
    when 19
      sentence =  "You are now sharing your " + item
    when 20
      sentence =  ""
    when 21
      sentence =  ""
    when 22
      sentence =  ""
    when 23
      sentence =  ""
    when 24
      sentence =  "Your " + item + " is damaged!" #this is duplicate of - 51
    when 25
      sentence =  "Your " + item + " is repaired!" #this is duplicate of - 52
    when 26
      sentence =  ""

      
      
    when 27
      sentence =  "You accepted " + person_possesive + " request for your " + item
    when 28
      sentence =  "You rejected " + person_possesive + " request for your " + item
    when 29
      sentence =  person + " accepted your request for their " + item
    when 30
      sentence =  person + " rejected your request for their " +  item
    when 31
      sentence =  person + " completed the action of receiving your " + item
    when 32
      sentence =  "You completed the action of receiving " + person_possesive + " " + item
    when 33
      sentence =  "You completed the action of gifting your " + item + " to " + person
    when 34
      sentence =  person + " completed the action of gifting their " + item + " to you"
    when 35
      sentence =  "You canceled the action of gifting your " + item + " to " + person 
    when 36
      sentence =  person + " canceled the action of gifting their " + item + " to you"
    when 37
      sentence =  person + " canceled the request for your " + item
    when 38
      sentence =  "You cancelled the request for " + person_possesive + " " + item 
      
    

=begin
    when 39
      sentence =  person + " made a request to borrow your " + item  #this is duplicate of  - 2, not used at this moment, left for possible future use
    when 40
      sentence =  "You made a request to borrow " + person_possesive + " " + item  #this is duplicate of - 3, not used at this moment, left for possible future use
    when 41
      sentence =  person + " confirmed you have a trusted relationship with them"
    when 42
      sentence =  "You confirmed you have a trusted relationship with " + person
    when 43
      sentence =  person + " denied you have a trusted relationship with them"
    when 44
      sentence =  "You denied you have a trusted relationship with " + person
    when 45
      sentence =  "You have withdrawn your trust for " + person
    when 46
      sentence =  person + " has withdrawn their trust for you"
    when 47
      sentence =  "You cancelled the establishment of a trusted relationship with " + person
    when 48
      sentence =  person + " cancelled the establishment of a trusted relationship with you"
    when 49
      sentence =  "You lost your " + item + "!"
    when 50
      sentence =  "You found your " + item + "!"
    when 51
      sentence =  "Your " + item + "is damaged!"    #this is duplicate of - when 24
    when 52
      sentence =  "Your " + item + " is repaired!"  #this is duplicate of - when 25
    when 53
      sentence =  "You removed your " + item + " from sharedearth.net"
    when 54
      sentence =  "You connected to sharedearth.net"
    when 55
      sentence =  person + " has left you positive feedback after borrowing your " + item
    when 56
      sentence =  person + " has left you positive feedback after sharing their " + item + " with you"
    when 57
      sentence =  person + " has left you negative feedback after borrowing your " + item
    when 58
      sentence =  person + " has left you negative feedback after sharing their " + item + " with you"
    when 59
      sentence =  person + " has left you neutral feedback after borrowing your " + item
    when 60
      sentence =  person + " has left you neutral feedback after sharing their " + item + " with you"
=end
      
    else
      #
    end
    
    sentence.html_safe
     
  end
end
