module PagesHelper
  #USE SAME METHOD TO DISPLAY MY EVENTS TO ME, AND MY EVENTS TO OTHER PERSON - SECOND PARAMETER INDICATES IF IT IS SHOWN TO OTHER PERSON IF NOT NIL
  def event_log_sentence(event_log, person, feed)
     
    @same_person = (person.nil? || (current_user.person == person)) ? true : false
    person||= current_user.person
    (feed == EventDisplay::RECENT_ACTIVITY_FEED) ? text_class = "normal" : text_class = ""

    @item                = link_to event_log.action_object_type_readable, item_path(event_log.action_object_id) unless event_log.action_object_type_readable.nil?

    @requester           = link_to_person event_log.primary, :downcase_you => true  unless event_log.primary.nil?
  	@requester_possesive = link_to_person event_log.primary, :downcase_you => true, :possessive => true unless event_log.primary.nil?
    @gifter              = link_to_person event_log.secondary, :downcase_you => true unless event_log.secondary.nil?
  	@gifter_possesive    = link_to_person event_log.secondary, :downcase_you => true, :possessive => true unless event_log.secondary.nil?

    @first_person_full  = link_to_person event_log.primary, :check_current_user => false, :downcase_you => true unless event_log.primary.nil?
    @second_person_full = link_to_person event_log.secondary, :check_current_user => false, :downcase_you => true unless event_log.secondary.nil?

    sentence = nil

    case event_log.event_type_id
    when 18
      sentence = sharing_sentence(event_log, person)
    when 19
      sentence = add_item_sentence(event_log, person)
    when 20
      sentence = negative_feedback_sentence(event_log, person)
    when 21
      sentence = gifting_sentence(event_log, person)
    when 22
      sentence = trust_established_sentence(event_log, person)
    when 23
      sentence = trust_withdrawn_sentence(event_log, person)
    when 24, 51
      sentence = item_damaged_sentence(event_log, person)
    when 25, 52
      sentence = item_repaired_sentence(event_log, person)
    when 26
      sentence = fb_friend_join_sentence(event_log, person)
    when 49
      #
    when 85
      sentence = shareage_sentence(event_log, person)
    else
      sentence = "dummy sentence"
    end

    # make first character of sentence capital if starting with you
    if sentence.starts_with?("you")
      return sentence.slice(0..0).capitalize + sentence.slice(1..-1)
    else
      return sentence
    end
      
  end
  
  def add_item_sentence(event_log, person)

    verb = verb_from_purpose(event_log.action_object)
   
    if event_log.involved_as_requester?(person)
       if @same_person
         sentence = "You are #{ verb } your" + " " + @item
       else
         sentence = @requester + " " + "is #{ verb } their" + " " + @item
       end
      
    else
      sentence = @requester + " " + "is #{ verb } their" + " " + @item
    end
    sentence.html_safe
  end
  
  def sharing_sentence(event_log, person)
  
   if event_log.involved_as_requester?(person)
     if @same_person
       sentence = "You borrowed " + @gifter_possesive + " " + @item
     else
       sentence = event_log.primary_full_name + " borrowed " + @gifter_possesive + " " + @item
     end
   elsif event_log.involved_as_gifter?(person)
     if @same_person
       sentence = @requester + " borrowed your " + @item
     else
       sentence = event_log.secondary_full_name + " shared their " + @item + " with " + @requester
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
       sentence = @requester + " received " + @gifter_possesive + " " + @item
     end
   elsif event_log.involved_as_gifter?(person)
     if @same_person
       sentence = "You gifted your " + @item + " to " +  @requester
     else
       sentence = @gifter + " gifted their " + @item + " to " +  @requester
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

  def shareage_sentence(event_log, person)
  
   if event_log.involved_as_requester?(person)
     if @same_person
       sentence = "You borrowed " + @gifter_possesive + " " + @item
     else
       sentence = @requester + " borrowed " + @gifter_possesive + " " + @item
     end
   elsif event_log.involved_as_gifter?(person)
     if @same_person
       sentence = @requester + ' borrowed your ' + @item
     else
       sentence = @gifter + " lent their " + @item + " to " +  @requester
     end
   elsif person.trusts?(event_log.primary) && !person.trusts?(event_log.secondary)
     sentence = @requester + " borrowed " + @gifter_possesive + " " + @item
	 elsif person.trusts?(event_log.primary) && person.trusts?(event_log.secondary)
     sentence = @gifter + " lent their " + @item + " to " + @requester
	 elsif person.trusts?(event_log.primary) && person.trusts?(event_log.secondary)
      sentence = @gifter + " lent their " + @item + " to " + @requester 
   else
     sentence = ""
   end
   
   sentence.html_safe
  end

  
  
  def trust_established_sentence(event_log, person)

    if event_log.involved_as_requester?(person)
      if @same_person
         sentence = "You have established a trusted relationship with " + @second_person_full
       else
         sentence = event_log.primary_full_name + " has established a trusted relationship with " + @second_person_full
      end
    elsif event_log.involved_as_gifter?(person)
      if @same_person
         sentence = "You have established a trusted relationship with " + @first_person_full
      else
         sentence = event_log.primary_full_name + " has established a trusted relationship with " + @first_person_full
      end
    elsif person.trusts?(event_log.primary)
      sentence = @first_person_full + " has established a trusted relationship with " + @second_person_full
    elsif person.trusts?(event_log.secondary)
      sentence = @second_person_full + " has established a trusted relationship with " + @first_person_full
    elsif person.trusts?(event_log.primary) && person.trusts?(event_log.secondary)
      sentence = @first_person_full + " and " + @second_person_full + " have established a trusted relationship"
    else 
      sentence = ""
    end

    sentence.html_safe
  end

  def trust_withdrawn_sentence(event_log, person)
    if event_log.involved_as_requester?(person)
      if @same_person
         sentence = "You have withdrawn your trust for " + @second_person_full
       else
         sentence = event_log.primary_full_name +  " has withdrawn their trust for " + @second_person_full
      end
    elsif event_log.involved_as_gifter?(person)
      if @same_person
         sentence = @first_person_full + " has withdrawn their trust for you"
      else
         sentence = @first_person_full + " has withdrawn their trust for " + event_log.secondary_full_name
      end
    elsif person.trusts?(event_log.primary)
      sentence = @first_person_full + " has withdrawn their trust for " + @second_person_full
    elsif person.trusts?(event_log.secondary)
      sentence = @second_person_full + " has withdrawn their trust for " + @first_person_full
    elsif person.trusts?(event_log.primary) && person.trusts?(event_log.secondary)
      sentence = @first_person_full + " has withdrawn their trust for " + @second_person_full
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
         sentence = event_log.primary_full_name.possessive + " " + @item + " " + "is broken"
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
         sentence = event_log.primary_full_name.possessive + " " + @item + " " + "has been repaired"
       end
    else
      sentence = @requester_possesive + " " + @item + " " + "has been repaired"
    end
    sentence.html_safe
  end
  
  def fb_friend_join_sentence(event_log, person)
    if person.id == event_log.primary_id
      sentence = "You have connected to sharedearth.net " 

    else
      sentence = @first_person_full + " has connected to sharedearth.net " 
    end

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
    when 39
      current_person
    when 40
      current_person
    when 41
      person
    when 42
      current_person
    when 43
      person
    when 44
      current_person
    when 45
      current_person
    when 46
      person
    when 47
      current_person
    when 48
      person
    when 49
      current_person
    when 51
      current_person
    when 52
      current_person
    when 53
      current_person
    when 54
      current_person
    when 55
      person
    when 56
      person
    when 57
      person
    when 58
      person
    when 59
      person
    when 60
      person
		when 61
      current_person
    when 62
      person
    when 63
      person
    when 64
      person
    when 65
      person
    when 66
      current_person
    when 67
      current_person
    when 68
      current_person
    when 69
      person
    when 70
      person
    when 71
      person
    when 72
      current_person
    when 73
      person
    when 74
      current_person
    when 75
      current_person
    when 76
      person
    when 77
      current_person
    when 78
      person
    when 79
      current_person
    when 80
      person
    when 81
      person
    when 82
      current_person
    when 83
      person
    when 84
      current_person
    #WHEN 85?
    when 86 #GIFTER CANCEL SHAREAGE GIFTER
      current_person
    when 87 #GIFTER CANCEL SHAREAGE REQUESTER
      person
    when 88 #REQUESTER CANCEL SHAREAGE GIFTER
      person
    when 89 #REQUESTER CANCEL SHAREAGE REQUESTER
      current_person
    when 90 #ACKNOWLEDGE RETURN SHAREAGE GIFTER
      current_person
    when 91 #ACKNOWLEDGE RETURN SHAREAGE REQUESTER
      person
    else
      current_person
    end
   
  end

  #Mature for refactoring!

  def build_recent_activity_sentence(activity_log, gifter, gifter_possesive, person, person_possesive, requester, requester_possesive, possesive, item, other_person, other_person_possesive)

	  sentence = ""
    case activity_log.event_type_id
    when 1
      sentence = "You are " + verb_from_purpose(activity_log.action_object) + " your " + item
    when 2
      sentence = requester + " made a request to borrow " + gifter_possesive + " " + item
    when 3
      sentence = requester + " made a request to borrow " + gifter_possesive + " " + item
    when 4
      sentence = gifter + " accepted " + requester_possesive + " request to borrow " + possesive + " " + item  # Check this one
    when 5
      sentence = gifter + " rejected " + requester_possesive + " request to borrow " + possesive + " " +  item  # Check this one
    when 6
      sentence = gifter + " accepted " + requester_possesive + " request to borrow " + possesive + " " + item
    when 7
      sentence = gifter + " rejected " + requester_possesive + " request to borrow " + possesive + " " + item
    when 8
      sentence = requester + " collected " + gifter_possesive + " " + item
    when 9
      sentence = requester + " collected " + gifter_possesive + " " +  item
    when 10
      sentence = requester + " completed the action of borrowing " + possesive + " " + item
    when 11
      sentence = requester + " completed the action of borrowing " + gifter_possesive + " " + item
    when 12
      sentence = gifter + " completed the action of sharing " + possesive + " " + item + " with " + requester
    when 13
      sentence = gifter + " completed the action of sharing their " + item + " with " + requester
    when 14
      sentence = gifter + " canceled sharing " + possesive + " " + item + " with " + requester
    when 15
      sentence = gifter + " canceled sharing their " + item + " with " + requester
    when 16
      sentence = requester + " canceled the request to borrow " + gifter_possesive + " " + item
    when 17
      sentence = requester + " canceled the request to borrow " + gifter_possesive + " " + item



    when 18
      sentence =  ""
    when 19
      sentence =  "You are " + verb_from_purpose(activity_log.action_object) + " your " + item
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
      sentence =  gifter + " accepted " + requester_possesive + " request for " + possesive + " " + item
    when 28
      sentence =  gifter + " rejected " + requester_possesive + " request for " + possesive + " " + item
    when 29
      sentence =  gifter + " accepted " + requester_possesive + " request for " + possesive + " " + item
    when 30
      sentence =  gifter + " rejected " + requester_possesive + " request for " + possesive + " " + item
    when 31
      sentence =  person + " completed the action of receiving your " + item
    when 32
      sentence =  "You received " + gifter_possesive + " " + item
    when 33
      sentence =  "You gifted your " + item + " to " + person
    when 34
      sentence =  person + " gifted their " + item + " to you"
    when 35
      sentence =  "You canceled gifting your " + item + " to " + person
    when 36
      sentence = gifter + " canceled gifting their " + item + " to " + requester
    when 37
      sentence =  requester + " canceled the request for " + gifter_possesive + " " + item
    when 38
      sentence =  requester + " canceled the request for " + gifter_possesive + " " + item

    #Check if sentence underneath are according to documentation, maybe they have changed
    when 39
      sentence =  "You connected to sharedearth.net"
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
    when 61
      sentence =  "You have indicated you have a trusted relationship with " + person
    when 62
      sentence =  person + " has indicated they have a trusted relationship with you"
    when 63
      action = activity_log.related.accepted? ? " action " : " request "
      sentence = person + " commented on the " + action  + " involving your " +  item
    when 64
      action = activity_log.related.accepted? ? " action " : " request "
      sentence = person + " commented on the " + action + " involving their " + item
    when 65 #SHAREAGE REQUEST GIFTER
      sentence = person + " requested your " + item + " for shareage"
    when 66 #SHAREAGE REQUEST REQUESTER
      sentence = "You requested " + other_person_possesive + " " + item + " for shareage"
    when 67 #ACCEPT SHAREAGE GIFTER
      sentence = "You accepted " + requester_possesive + " request for your " + item
    when 68 #REJECT SHAREAGE GIFTER
      sentence = "You rejected " + other_person_possesive + " request for your " + item
    when 69 #ACCEPT SHAREAGE REQUESTER
      sentence = other_person + " accepted your request for their " + item
    when 70 #REJECT SHAREAGE REQUESTER
      sentence = other_person + " rejected your request for their " + item
    when 71 #COLLECTED SHAREAGE GIFTER
      sentence = "Your " + item + " is now in shareage with " + requester
    when 72 #COLLECTED SHAREAGE REQUESTER
      sentence = "You have collected " + other_person_possesive + " " + item + " for shareage"
    when 73 #RETURN SHAREAGE GIFTER
      sentence = requester + " would like to return your " + item
    when 74 #RETURN SHAREAGE REQUESTER
      sentence = "You have requested the return of " + gifter_possesive + " " + item
    when 75 #RECALL SHAREAGE GIFTER
      sentence = "You have recalled your " + item + " from " + requester
    when 76 #RECALL SHAREAGE REQUESTER
      sentence = person + " requested the return of their " + item
    when 77 #CANCEL RECALL SHAREAGE GIFTER
      sentence = "You cancelled the recall of your " + item + " from " + requester
    when 78 #CANCEL RECALL SHAREAGE REQUESTER
      sentence = other_person + " cancelled the recall of their " + item
    when 79 #ACKNOWLEDGE SHAREAGE GIFTER
      sentence = other_person + " acknowledged your request for your " +item
    when 80 #ACKNOWLEDGE SHAREAGE REQUESTER
      sentence = "You acknowledged " + requester_possesive + " request for their " + item
    when 81 #RETURNED SHAREAGE GIFTER
      sentence = requester + " returned your  " + item
    when 82 #RETURNED SHAREAGE REQUESTER
      sentence = "You returned " + other_person_possesive + " " +item
    when 83 #CANCEL RETURN SHAREAGE GIFTER
      sentence = requester + " cancelled the request to return your " + item
    when 84 #CANCEL RETURN SHAREAGE REQUESTER
      sentence = "You cancelled the request to return " + gifter_possesive + " " + item
    when 85 #SHAREAGE
      sentence = ""
    when 86 #GIFTER CANCEL SHAREAGE GIFTER
      sentence =  "You canceled placing your " + item + " into shareage with " + person
    when 87 #GIFTER CANCEL SHAREAGE REQUESTER
      sentence = gifter + " canceled placing their " + item + " into shareage with you"
    when 88 #REQUESTER CANCEL SHAREAGE GIFTER
      sentence =  requester + " canceled the request for " + gifter_possesive + " " + item
    when 89 #REQUESTER CANCEL SHAREAGE REQUESTER
      sentence =  requester + " canceled the request for " + gifter_possesive + " " + item
    when 90 #ACKNOWLEDGE RETURN SHAREAGE GIFTER
      sentence = "You acknowledged " + requester_possesive + " request to return your " + item
    when 91 #ACKNOWLEDGE RETURN SHAREAGE REQUESTER
      sentence = other_person + " acknowledged your request to return their " +item
    else
      #
    end
    sentence.html_safe
  end

  def recent_activity_sentence(activity_log)
    gifter, gifter_possesive, person, person_possesive, requester, requester_possesive = "", "", "", "", "", ""
    item = activity_log.action_object
    unless activity_log.secondary_full_name.nil? || item.nil?
      gifter_person = nil
			
	  unless [3, 6, 7, 9, 11, 13, 15, 17, 29, 30, 32, 34, 36, 38, 74, 84, 87, 89].include?(activity_log.event_type_id.to_i) # event types where roles are reversed
	    requester           = link_to_person activity_log.secondary, :class => "positive"
	    requester_possesive = link_to_person activity_log.secondary, :possessive => true, :downcase_you => true, :class => "positive"
        gifter              = link_to_person activity_log.primary, :class => "positive"
		gifter_possesive    = link_to_person activity_log.primary, :possessive => true, :downcase_you => true, :class => "positive"
        gifter_person       = activity_log.primary
      else
        gifter              = link_to_person activity_log.secondary, :class => "positive"
        gifter_possesive    = link_to_person activity_log.secondary, :possessive => true, :downcase_you => true, :class => "positive"
		requester           = link_to_person activity_log.primary, :class => "positive"
		requester_possesive = link_to_person activity_log.primary, :possessive => true, :downcase_you => true, :class => "positive"

        gifter_person = activity_log.secondary
      end

      possesive = ( gifter_person == current_user.person ) ? "your" : "their"
    end

    item = link_to activity_log.action_object_type_readable, item_path(activity_log.action_object), :class => "item-link" unless activity_log.action_object.nil?

    unless activity_log.secondary.nil?
      person                  = link_to_person activity_log.secondary, :check_current_user => false, :class => "positive"
      other_person            = link_to_person activity_log.secondary, :check_current_user => false, :class => "positive"
      other_person_possesive  = link_to_person activity_log.secondary, :check_current_user => false, :possessive => true, :class => "positive"
      person_possesive        = link_to_person activity_log.primary, :check_current_user => false, :possessive => true, :class => "positive"
    end

    build_recent_activity_sentence(activity_log, gifter, gifter_possesive, person, person_possesive, requester, requester_possesive, possesive, item, other_person, other_person_possesive)
  end

  def notify_recent_activity_sentence(activity_log, current_user)
    gifter, gifter_possesive, person, person_possesive, requester, requester_possesive = "", "", "", "", "", ""
    item = activity_log.action_object
    unless activity_log.secondary_full_name.nil? || item.nil?

      unless [3, 6, 7, 9, 11, 13, 15, 17, 29, 30, 32, 34, 36, 38, 74, 84, 87].include?(activity_log.event_type_id.to_i) # event types where roles are reversed
        requester           = (activity_log.secondary == current_user.person) ? "You" : activity_log.secondary_full_name
        requester_possesive = (activity_log.secondary == current_user.person) ? "your" : activity_log.secondary_full_name.possessive
        gifter              =  (activity_log.primary == current_user.person) ? "You" : activity_log.primary.name
        gifter_possesive    = (activity_log.primary == current_user.person) ? "your" : activity_log.primary.name.possessive
      else
        gifter              = (activity_log.secondary == current_user.person) ? "You" : activity_log.secondary_full_name
        gifter_possesive    = (activity_log.secondary == current_user.person) ? "your" : activity_log.secondary_full_name.possessive
        requester           = (activity_log.primary == current_user.person) ? "You" : activity_log.primary.name
        requester_possesive = (activity_log.primary == current_user.person) ? "your" : activity_log.primary.name.possessive
      end

      possesive = item.is_owner?(current_user.person) ? "your" : "their"
    end

    item = activity_log.action_object_type_readable unless activity_log.action_object.nil?

    unless activity_log.secondary.nil?
      person                  = activity_log.secondary_full_name
      other_person            = activity_log.secondary_full_name
      person_possesive        = activity_log.secondary_full_name.possessive
      other_person_possesive  = activity_log.secondary_full_name.possessive
    end
	
    build_recent_activity_sentence(activity_log, gifter, gifter_possesive, person, person_possesive, requester, requester_possesive, possesive, item, other_person, other_person_possesive)
  end
  
  def show_comments(log)
    related = log.related
    case related
      when "ItemRequest"
        s = link_to request_path(related)
      else
      #
        
    end
    s.safe_html
  
  end
  
  def event_actions(log)
    comments = log.comments.count
    begin
      case log.event_type.name
        when 'SHARING'
          res = "#{link_to "view action", request_path(log.related)} <a href='#' class=\"comments-show-hide\">comments(#{comments ||= 0})</a>"
        when 'ADD ITEM'
          
          res = links_for_add_item(log, comments)
          puts res
        when 'NEGATIVE FEEDBACK'
          res = "#{link_to "view feedback", request_path(log.related)} <a href='#' class=\"comments-show-hide\">comments(#{comments ||= 0})</a>"
        when 'GIFTING'
          res = "#{link_to "view action", request_path(log.related)} <a href='#' class=\"comments-show-hide\">comments(#{comments ||= 0})</a>"
        when 'TRUST ESTABLISHED'
          res = "<a href='#' class=\"comments-show-hide\">comments(#{comments ||= 0})</a>"
        when 'TRUST WITHDRAWN'
          res = "<a href='#' class=\"comments-show-hide\">comments(#{comments ||= 0})</a>"
        when 'ITEM DAMAGED'
          res = "#{link_to "view item1", item_path(log.related)} <a href='#' class=\"comments-show-hide\">comments(#{comments ||= 0})</a>"  
        when 'ITEM REPAIRED'
            res = "#{link_to "view item2", item_path(log.related)} <a href='#' class=\"comments-show-hide\">comments(#{comments ||= 0})</a>"  
        when 'FB FRIEND JOIN'
          res = "#{link_to "view profile", person_path(log.primary)} <a href='#' class=\"comments-show-hide\">comments(#{comments ||= 0})</a>"  
        else
          res = ""
      end
      
    rescue Exception => e
      res = ""
    end
    res.html_safe
  end
  
  protected
  
  def verb_from_purpose(item)
		verb = "now sharing"
		if item.gift?
			verb = "gifting"
		elsif item.share?
			verb = "now sharing"
		end
		verb
  end
 
 private
  def links_for_add_item(log, comments)
    share_mine_link = ""
     share_mine_link = "<td>#{link_to "share mine", "#", :action => share_mine_item_path(log.action_object_id), :remote => 'true',  :id => "share_mine_#{log.action_object_id}"}</td>" unless log.involved_as_requester?current_user.person
    "<table><tr><td>#{link_to "abc" , item_path(log.action_object_id)}</td>#{share_mine_link}<td><a href='#' class=\"comments-show-hide\">comments(#{comments ||= 0})</a></td></td></table>"
  end

end
