module PagesHelper
  #USE SAME METHOD TO DISPLAY MY EVENTS TO ME, AND MY EVENTS TO OTHER PERSON - SECOND PARAMETER INDICATES IF IT IS SHOWN TO OTHER PERSON IF NOT NIL
  def event_log_sentence(event_log, person, feed)
    
    @same_person = (person.nil? || (current_user.person == person)) ? true : false
    person||= current_user.person
    (feed == EventDisplay::RECENT_ACTIVITY_FEED) ? text_class = "normal" : text_class = ""

    @item                = link_to event_log.action_object_type_readable, item_path(event_log.action_object_id), :class => text_class unless event_log.action_object_type_readable.nil?
    @primary             = link_to_person event_log.primary, :downcase_you => true, :class => text_class unless event_log.primary.nil?
    @requester           = link_to_person event_log.primary, :downcase_you => true, :class => text_class  unless event_log.primary.nil?
  	@requester_possesive = link_to_person event_log.primary, :downcase_you => true, :possessive => true, :class => text_class unless event_log.primary.nil?
	@secondary           = link_to_person event_log.secondary, :downcase_you => true, :class => text_class unless event_log.secondary.nil?
	@secondary_possessive= link_to_person event_log.secondary, :downcase_you => true, :possessive => true, :class => text_class unless event_log.secondary.nil?
    @gifter              = link_to_person event_log.secondary, :downcase_you => true, :class => text_class unless event_log.secondary.nil?
  	@gifter_possesive    = link_to_person event_log.secondary, :downcase_you => true, :possessive => true, :class => text_class unless event_log.secondary.nil?

    @first_person_full  = link_to_person event_log.primary, :check_current_user => false, :downcase_you => true unless event_log.primary.nil?
    @second_person_full = link_to_person event_log.secondary, :check_current_user => false, :downcase_you => true unless event_log.secondary.nil?

    sentence = nil

    case event_log.event_type_id
    when 18
      sentence = sharing_sentence(event_log)
    when 19
      sentence = add_item_sentence(event_log, person)
    when 21
      sentence = gifting_sentence(event_log)
    when 22
      sentence = trust_established_sentence(event_log)
    when 23
      sentence = trust_withdrawn_sentence(event_log)
    when 24
      sentence = item_damaged_sentence(event_log, person)
    when 25
      sentence = item_repaired_sentence(event_log, person)
    when 26
      sentence = fb_friend_join_sentence(event_log, person)
    when 49
      #
    when 55
      sentence = gifter_positive_feedback_sentence(event_log)
    when 56
      sentence = requester_positive_feedback_sentence(event_log)
    when 57
      sentence = gifter_negative_feedback_sentence(event_log)
    when 58
      sentence = requester_negative_feedback_sentence(event_log)
    when 59
      sentence = gifter_neutral_feedback_sentence(event_log)
    when 60
      sentence = requester_neutral_feedback_sentence(event_log)
    when 85
      sentence = shareage_sentence(event_log)
    when 98
      sentence = gift_gifter_positive_feedback_sentence(event_log)
    when 100
      sentence = gift_requester_positive_feedback_sentence(event_log)
    when 102
      sentence = gift_gifter_negative_feedback_sentence(event_log)
    when 105
      sentence = gift_requester_negative_feedback_sentence(event_log)
    when 106
      sentence = gift_gifter_neutral_feedback_sentence(event_log)
    when 108
      sentence = gift_requester_neutral_feedback_sentence(event_log)
    when 110 
      sentence = shareage_gifter_positive_feedback_sentence(event_log)
    when 112
      sentence = shareage_requester_positive_feedback_sentence(event_log)
    when 114
      sentence = shareage_gifter_negative_feedback_sentence(event_log)
    when 116
      sentence = shareage_requester_negative_feedback_sentence(event_log)
    when 118
      sentence = shareage_gifter_neutral_feedback_sentence(event_log)
    when 120
      sentence = shareage_requester_neutral_feedback_sentence(event_log)
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
         sentence = "I am #{ verb } my" + " " + @item
       else
         sentence = @requester + " " + "is #{ verb } their" + " " + @item
       end
    else
      sentence = @requester + " " + "is #{ verb } their" + " " + @item
    end
    
    sentence.html_safe
  end
  
  def sharing_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I borrowed " + @secondary_possessive + " " + @item 
    elsif person.id == event_log.secondary_id
      sentence = @primary + " borrowed my " + @item
    else
      sentence = @primary + " borrowed " + @secondary_possessive + " " + @item
    end
   
    sentence.html_safe
  end
  
  def gifting_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = @secondary + " gifted their " + @item + " to me" 
    elsif person.id == event_log.secondary_id
      sentence = "I gifted my " + @item + " to " + @primary
    else
      sentence = @secondary + " gifted their " + @item + " to " + @primary
    end
   
    sentence.html_safe
  end

  def shareage_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I borrowed " + @secondary_possessive + " " + @item 
    elsif person.id == event_log.secondary_id
      sentence = @primary + " borrowed my " + @item
    else
      sentence = @secondary + " lent their " + @item + " to " + @primary
    end
   
    sentence.html_safe
  end

  def trust_established_sentence(event_log)
	person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have established a trusted relationship with " + @second_person_full
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has established a trusted relationship with me"
    else
      sentence = @primary + " has established a trusted relationship with " + @secondary 
    end

    sentence.html_safe
  end

  def trust_withdrawn_sentence(event_log)
	person = current_user.person
	if person.id == event_log.primary_id
	  sentence = "I have withdrawn my trust for " + @second_person_full
	elsif person.id == event_log.secondary_id
	  sentence = @primary + " has withdrawn their trust for me"
	else 
	  sentence = @primary + " has withdrawn trust for " + @second_person_full
	end
    
    sentence.html_safe
  end
  
  def item_damaged_sentence(event_log, person)
    if event_log.action_object.is_owner?(person)
       if @same_person
         sentence = "My " + " " + @item + " " + "is broken"
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
         sentence = "My " + " " + @item + " " + "has been repaired"
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
      sentence = "I have connected to sharedearth.net " 

    else
      sentence = @first_person_full + " has connected to sharedearth.net " 
    end

    sentence.html_safe 
  end

  def gifter_positive_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " positive feedback after sharing my " + @item + " with them"
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me positive feedback after sharing their " + @item + " with me"
    else
      sentence = @primary + " has left " + @secondary + " positive feedback after sharing their " + @item + " with them"
    end
    
    sentence.html_safe
  end
  
  def gift_gifter_positive_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " positive feedback after gifting my " + @item + " to them"
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me positive feedback after gifting their " + @item + " to me"
    else 
      sentence = @primary + " has left " + @secondary + " positive feedback after gifting their " + @item + " to them"
    end
    
    sentence.html_safe
  end
  
  def shareage_gifter_positive_feedback_sentence(event_log)
	person = current_user.person
	if person.id == event_log.primary_id
	  sentence = "I have left " + @secondary + " positive feedback after the shareage of my " + @item + " with them"
	elsif person.id == event_log.secondary_id 
	  sentence = @primary + " has left me positive feedback after the shareage of their " + @item + " with me"
	else
	  sentence = @primary + " has left " + @secondary + " positive feedback after the shareage of their " + @item + " with them"
	end
	
	sentence.html_safe
  end
 
  def requester_positive_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " positive feedback after borrowing their " + @item
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me positive feedback after borrowing my " + @item
    else
      sentence = @primary + " has left " + @secondary + " positive feedback after borrowing their " + @item 
    end
    
    sentence.html_safe
  end
  
  def gift_requester_positive_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " positive feedback after receiving their " + @item
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me positive feedback after receiving my " + @item
    else
      sentence = @primary + " has left " + @secondary + " positive feedback after receiving their " + @item 
    end
    
    sentence.html_safe
  end
  
  def shareage_requester_positive_feedback_sentence(event_log)
	person = current_user.person
	if person.id == event_log.primary_id
	  sentence = "I have left " + @secondary + " positive feedback after the shareage of their " + @item
	elsif person.id == event_log.secondary_id
	  sentence = @primary + " has left me positive feedback after the shareage of my " + @item
	else
	  sentence = @primary + " has left " + @secondary + " positive feedback after the shareage of their " + @item 
	end
	
	sentence.html_safe
  end
  
  def gifter_negative_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id 
      sentence = "I have left " + @secondary + " negative feedback after sharing my " + @item + " with them"
    elsif person.id == event_log.secondary_id 
      sentence = @primary + " has left me negative feedback after sharing their " + @item + " with me"
    else 
     sentence = @primary + " has left " + @secondary + " negative feedback after sharing their " + @item + " with them"
    end 
    
    sentence.html_safe
  end
  
  def gift_gifter_negative_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " negative feedback after gifting my " + @item + " to them"
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me negative feedback after gifting their " + @item + " to me"
    else
      sentence = @primary + " has left " + @secondary + " negative feedback after gifting their " + @item + " to them"
    end
    
    sentence.html_safe
  end
  
  def shareage_gifter_negative_feedback_sentence(event_log)
	person = current_user.person
	if person.id == event_log.primary_id
	  sentence = "I have left " + @secondary + " negative feedback after the shareage of my " + @item + " with them"
	elsif person.id == event_log.secondary_id
	  sentence = @primary + " has left me negative feedback after the shareage of their " + @item + " with me"
	else
	  sentence = @primary + " has left " + @secondary + " negative feedback after the shareage of their " + @item + " with them"
	end
	
	sentence.html_safe
  end
  
  def requester_negative_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " negative feedback after borrowing their " + @item
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me negative feedback after borrowing my " + @item
    else
      sentence = @primary + " has left " + @secondary + " negative feedback after borrowing their " + @item 
    end
    
    sentence.html_safe
  end
  
  def gift_requester_negative_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " negative feedback after receiving their " + @item
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me negative feedback after receiving my " + @item
    else
      sentence = @primary + " has left " + @secondary + " negative feedback after receiving their " + @item 
    end
    
    sentence.html_safe
  end
  
  def shareage_requester_negative_feedback_sentence(event_log)
	person = current_user.person
	if person.id == event_log.primary_id
	  sentence = "I have left " + @secondary + " negative feedback after the shareage of their " + @item
	elsif person.id == event_log.secondary_id
	  sentence = @primary + " has left me negative feedback after the shareage of my " + @item
	else
	  sentence = @primary + " has left " + @secondary + " negative feedback after the shareage of their " + @item 
	end
	
	sentence.html_safe
  end

  def gifter_neutral_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " neutral feedback after sharing my " + @item + " with them"
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me neutral feedback after sharing their " + @item + " with me"
    else
      sentence = @primary + " has left " + @secondary + " neutral feedback after sharing their " + @item + " with them"
    end
    
    sentence.html_safe
  end
  
  def gift_gifter_neutral_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " neutral feedback after gifting my " + @item + " to them"
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me neutral feedback after gifting their " + @item + " to me"
    else
      sentence = @primary + " has left " + @secondary + " neutral feedback after gifting their " + @item + " to them"
    end
    
    sentence.html_safe
  end
  
  def shareage_gifter_neutral_feedback_sentence(event_log)
	person = current_user.person
	if person.id == event_log.primary_id
	  sentence = "I have left " + @secondary + " neutral feedback after the shareage of my " + @item + " with them"
	elsif person.id == event_log.secondary_id
	  sentence = @primary + " has left me neutral feedback after the shareage of their " + @item + " with me"
	else
	  sentence = @primary + " has left " + @secondary + " neutral feedback after the shareage of their " + @item + " with them"
	end
	
	sentence.html_safe
  end
 
  def requester_neutral_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " neutral feedback after borrowing their " + @item
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me neutral feedback after borrowing my " + @item
    else
      sentence = @primary + " has left " + @secondary + " neutral feedback after borrowing their " + @item
    end
    
    sentence.html_safe
  end
  
  def gift_requester_neutral_feedback_sentence(event_log)
    person = current_user.person
    if person.id == event_log.primary_id
      sentence = "I have left " + @secondary + " neutral feedback after receiving their " + @item
    elsif person.id == event_log.secondary_id
      sentence = @primary + " has left me neutral feedback after receiving my " + @item
    else
      sentence = @primary + " has left " + @secondary + " neutral feedback after receiving their " + @item
    end
    
    sentence.html_safe
  end
  
  def shareage_requester_neutral_feedback_sentence(event_log)
	person = current_user.person
	if person.id == event_log.primary_id
	  sentence = "I have left " + @secondary + " neutral feedback after the shareage of their " + @item
	elsif person.id == event_log.secondary_id
	  sentence = @primary + " has left me neutral feedback after the shareage of my " + @item
	else
	  sentence = @primary + " has left " + @secondary + " neutral feedback after the shareage of their " + @item
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
    when 2
      sentence = requester + " would like to borrow " + gifter_possesive + " " + item
    when 3
      sentence = requester + " asked to borrow " + gifter_possesive + " " + item
    when 4
      sentence = gifter + " accepted " + requester_possesive + " request to borrow " + possesive + " " + item  # Check this one
    when 5
      sentence = gifter + " declined " + requester_possesive + " request to borrow " + possesive + " " +  item  # Check this one
    when 6
      sentence = gifter + " accepted " + requester_possesive + " request to borrow " + possesive + " " + item
    when 7
      sentence = gifter + " declined " + requester_possesive + " request to borrow " + possesive + " " + item
    when 8
      sentence = requester + " collected " + gifter_possesive + " " + item
    when 9
      sentence = requester + " collected " + gifter_possesive + " " +  item
    when 10
      sentence = requester + " has finished borrowing " + possesive + " " + item
    when 11
      sentence = requester + " finished borrowing " + gifter_possesive + " " + item
    when 12
      sentence = gifter + " finished lending " + possesive + " " + item + " to " + requester
    when 13
      sentence = gifter + " finished lending their " + item + " to " + "me"
    when 14
      sentence = gifter + " canceled sharing " + possesive + " " + item + " with " + requester
    when 15
      sentence = gifter + " canceled sharing their " + item + " with " + "me"
    when 16
      sentence = requester + " canceled their request to borrow " + gifter_possesive + " " + item
    when 17
      sentence = requester + " canceled my request to borrow " + gifter_possesive + " " + item

    when 19
      sentence =  "I added my " + item + " for " + phrase_from_purpose(activity_log.action_object) 

    when 27
      sentence =  gifter + " accepted " + requester_possesive + " request for " + possesive + " " + item
    when 28
      sentence =  gifter + " declined " + requester_possesive + " request for " + possesive + " " + item
    when 29
      sentence =  gifter + " accepted " + requester_possesive + " request for " + possesive + " " + item
    when 30
      sentence =  gifter + " declined " + requester_possesive + " request for " + possesive + " " + item
    when 31
      sentence =  person + " received " + gifter_possesive + " " + item
    when 32
      sentence =  "I received " + gifter_possesive + " " + item
    when 33
      sentence =  "I gifted my " + item + " to " + person
    when 34
      sentence =  person + " gifted their " + item + " to me"
    when 35
      sentence =  "I canceled gifting my " + item + " to " + person
    when 36
      sentence = gifter + " canceled gifting their " + item + " to " + "me"
    when 37
      sentence =  requester + " canceled the request for " + gifter_possesive + " " + item
    when 38
      sentence =  requester + " canceled the request for " + gifter_possesive + " " + item

    #Check if sentence underneath are according to documentation, maybe they have changed
    when 39
      sentence =  "I connected to sharedearth.net"
    when 41
      sentence =  person + " confirmed we have a trusted relationship"
    when 42
      sentence =  "I confirmed I have a trusted relationship with " + person
    when 45
      sentence =  "I have withdrawn my trust for " + person
    when 46
      sentence =  person + " has withdrawn their trust for me"
    when 49
      sentence =  "I lost my " + item + "!"
    when 50
      sentence =  "I found my " + item + "!"
    when 51
      sentence =  "My " + item + " is damaged!"    #this is duplicate of - when 24
    when 52
      sentence =  "My " + item + " is repaired!"  #this is duplicate of - when 25
    when 53
      sentence =  "I removed my " + item + " from sharedearth.net"
    when 55
      sentence = "I have left " + requester + " positive feedback after sharing my " + item + " with them"
    when 92
      sentence = person + " has left me positive feedback after sharing their " + item + " with me" 
    when 56
      sentence = requester + " has left me positive feedback after borrowing my " + item
    when 93
      sentence = "I have left " + person + " positive feedback after borrowing their " + item
    when 57
      sentence =  "I have left " + requester + " negative feedback after sharing my " + item + " with them"
    when 94
      sentence = person + " has left me negative feedback after sharing their " + item + " with me"
    when 58
      sentence =  requester + " has left me negative feedback after borrowing my " + item
    when 95
      sentence = "I have left " + person + " negative feedback after borrowing their " + item
    when 59
      sentence =  "I have left " + requester + " neutral feedback after sharing my " + item + " with them"
    when 96
      sentence = person + " has left me neutral feedback after sharing their " + item + " with me"
    when 60
      sentence =  requester + " has left me neutral feedback after borrowing my " + item
    when 97
      sentence = "I have left " + person + " neutral feedback after borrowing their " + item
    when 61
      sentence =  "I have indicated I have a trusted relationship with " + person
    when 62
      sentence =  person + " has indicated they have a trusted relationship with me"
    when 63
      action = activity_log.related.accepted? ? " action " : " request "
      sentence = person + " commented on the " + action  + " involving my " +  item
    when 64
      action = activity_log.related.accepted? ? " action " : " request "
      sentence = person + " commented on the " + action + " involving their " + item
    when 65 #SHAREAGE REQUEST GIFTER
      sentence = person + " requested my " + item + " for shareage"
    when 66 #SHAREAGE REQUEST REQUESTER
      sentence = "I requested " + other_person_possesive + " " + item + " for shareage"
    when 67 #ACCEPT SHAREAGE GIFTER
      sentence = "I accepted " + requester_possesive + " request for my " + item
    when 68 #REJECT SHAREAGE GIFTER
      sentence = "I declined " + other_person_possesive + " request for my " + item
    when 69 #ACCEPT SHAREAGE REQUESTER
      sentence = other_person + " accepted my request for their " + item
    when 70 #REJECT SHAREAGE REQUESTER
      sentence = other_person + " declined my request for their " + item
    when 71 #COLLECTED SHAREAGE GIFTER
      sentence = "My " + item + " is now in shareage with " + requester
    when 72 #COLLECTED SHAREAGE REQUESTER
      sentence = "I have collected " + other_person_possesive + " " + item + " for shareage"
    when 73 #RETURN SHAREAGE GIFTER
      sentence = requester + " would like to return my " + item
    when 74 #RETURN SHAREAGE REQUESTER
      sentence = "I have requested the return of " + gifter_possesive + " " + item
    when 75 #RECALL SHAREAGE GIFTER
      sentence = "I have recalled my " + item + " from " + requester
    when 76 #RECALL SHAREAGE REQUESTER
      sentence = person + " requested the return of their " + item
    when 77 #CANCEL RECALL SHAREAGE GIFTER
      sentence = "I canceled the recall of my " + item + " from " + requester
    when 78 #CANCEL RECALL SHAREAGE REQUESTER
      sentence = other_person + " canceled the recall of their " + item
    when 79 #ACKNOWLEDGE SHAREAGE GIFTER
      sentence = other_person + " acknowledged my request for my " +item
    when 80 #ACKNOWLEDGE SHAREAGE REQUESTER
      sentence = "I acknowledged " + requester_possesive + " request for their " + item
    when 81 #RETURNED SHAREAGE GIFTER
      sentence = requester + " returned my " + item
    when 82 #RETURNED SHAREAGE REQUESTER
      sentence = "I returned " + other_person_possesive + " " +item
    when 83 #CANCEL RETURN SHAREAGE GIFTER
      sentence = requester + " canceled the request to return my " + item
    when 84 #CANCEL RETURN SHAREAGE REQUESTER
      sentence = "I canceled the request to return " + gifter_possesive + " " + item
    when 86 #GIFTER CANCEL SHAREAGE GIFTER
      sentence =  "I canceled placing my " + item + " into shareage with " + person
    when 87 #GIFTER CANCEL SHAREAGE REQUESTER
      sentence = gifter + " canceled placing their " + item + " into shareage with me"
    when 88 #REQUESTER CANCEL SHAREAGE GIFTER
      sentence =  requester + " canceled the request for " + gifter_possesive + " " + item
    when 89 #REQUESTER CANCEL SHAREAGE REQUESTER
      sentence =  requester + " canceled the request for " + gifter_possesive + " " + item
    when 90 #ACKNOWLEDGE RETURN SHAREAGE GIFTER
      sentence = "I acknowledged " + requester_possesive + " request to return my " + item
    when 91 #ACKNOWLEDGE RETURN SHAREAGE REQUESTER
      sentence = other_person + " acknowledged my request to return their " + item
	when 98 #GIFT GIFTER POSITIVE FEEDBACK GIFTER
	  sentence = "I have left " + requester + " positive feedback after gifting my " + item + " to them"
	when 99 #GIFT GIFTER POSITIVE FEEDBACK REQUESTER
	  sentence = person + " has left me positive feedback after gifting their " + item + " to me"
	when 100 #GIFT REQUESTER POSITIVE FEEDBACK REQUESTER
	  sentence = requester + " has left me positive feedback after receiving my " + item
	when 101 #GIFT REQUESTER POSITIVE FEEDBACK GIFTER 
	  sentence = "I have left " + person + " positive feedback after receiving their " + item
	when 102 #GIFT GIFTER NEGATIVE FEEDBACK GIFTER
	  sentence = "I have left " + requester + " negative feedback after gifting my " + item + " to them"
	when 103 #GIFT GIFTER NEGATIVE FEEDBACK REQUESTER
	  sentence = person + " has left me negative feedback after gifting their " + item + " to me"
	when 104 #GIFT REQUESTER NEGATIVE FEEDBACK REQUESTER 
	  sentence = "I have left " + person + " negative feedback after receiving their " + item
	when 105 #GIFT REQUESTER NEGATIVE FEEDBACK GIFTER 
	  sentence = requester + " has left me negative feedback after receiving my " + item
	when 106 #GIFT GIFTER NEUTRAL FEEDBACK GIFTER 
	  sentence = "I have left " + requester + " neutral feedback after gifting my " + item + " to them"
	when 107 #GIFT GIFTER NEUTRAL FEEDBACK REQUESTER 
	  sentence = person + " has left me neutral feedback after gifting their " + item + " to me"
	when 108 #GIFT REQUESTER NEUTRAL FEEDBACK REQUESTER 
	  sentence = requester + " has left me neutral feedback after receiving my " + item
	when 109 #GIFT REQUESTER NEUTRAL FEEDBACK GIFTER 
	  sentence = "I have left " + person + " neutral feedback after receiving their " + item
	when 110 #SHAREAGE GIFTER POSITIVE FEEDBACK GIFTER 
	  sentence = "I have left " + requester + " positive feedback after the shareage of my " + item + " with them"
	when 111 #SHAREAGE GIFTER POSITIVE FEEDBACK RQUESTER 
	  sentence = person + " has left me positive feedback after the shareage of their " + item + " with me"
	when 112 #SHAREAGE REQUESTER POSITIVE FEEDBACK REQUESTER 
	  sentence = requester + " has left me positive feedback after the shareage of my " + item
	when 113 #SHAREAGE REQUESTER POSITIVE FEEDBACK GIFTER 
	  sentence = "I have left " + person + " positive feedback after the shareage of their " + item
	when 114 #SHAREAGE GIFTER NEGATIVE FEEDBACK GIFTER 
	  sentence = "I have left " + requester + " negative feedback after the shareage of my " + item + " with them"
	when 115 #SHAREAGE GIFTER NEGATIVE FEEDBACK REQUESTER 
	  sentence = person + " has left me negative feedback after the shareage of their " + item + " with me"
	when 116 #SHAREAGE REQUESTER NEGATIVE FEEDBACK REQUESTER
	  sentence = requester + " has left me negative feedback after the shareage of my " + item
	when 117 #SHAREAGE REQUESTER NEGATIVE FEEDBACK GIFTER 
	  sentence = "I have left " + person + " negative feedback after the shareage of their " + item
	when 118 #SHAREAGE GIFTER NEUTRAL FEEDBACK GIFTER 
	  sentence = "I have left " + requester + " neutral feedback after the shareage of my " + item + " with them"
	when 119 #SHAREAGE GIFTER NEUTRAL FEEDBACK REQUESTER 
	  sentence = person + " has left me neutral feedback after the shareage of their " + item + " with me"
	when 120 #SHAREAGE REQUESTER NEUTRAL FEEDBACK REQUESTER 
	  sentence = requester + " has left me neutral feedback after the shareage of my " + item
	when 121 #SHAREAGE REQUESTER NEUTRAL FEEDBACK GIFTER 
	  sentence = "I have left " +person + " neutral feedback after the shareage of their " + item
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

      possesive = ( gifter_person == current_user.person ) ? "my" : "their"
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
        requester_possesive = (activity_log.secondary == current_user.person) ? "my" : activity_log.secondary_full_name.possessive
        gifter              =  (activity_log.primary == current_user.person) ? "You" : activity_log.primary.name
        gifter_possesive    = (activity_log.primary == current_user.person) ? "my" : activity_log.primary.name.possessive
      else
        gifter              = (activity_log.secondary == current_user.person) ? "You" : activity_log.secondary_full_name
        gifter_possesive    = (activity_log.secondary == current_user.person) ? "my" : activity_log.secondary_full_name.possessive
        requester           = (activity_log.primary == current_user.person) ? "You" : activity_log.primary.name
        requester_possesive = (activity_log.primary == current_user.person) ? "my" : activity_log.primary.name.possessive
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
  
  def phrase_from_purpose(item)
    phrase = "people to borrow"
    if item.gift?
      phrase = "someone to have"
    elsif item.share?
      verb = "people to borrow"
    end
    phrase
  end
 
 private
  def links_for_add_item(log, comments)
    share_mine_link = ""
     share_mine_link = "<td  style='padding-left:4px;'>#{link_to "share mine", "#", :action => share_mine_item_path(log.action_object_id), :remote => 'true',  :id => "share_mine_#{log.action_object_id}"}</td>" unless log.involved_as_requester?current_user.person
    "<table><tr><td style='padding-left:0px;'>#{link_to "abc" , item_path(log.action_object_id)}</td>#{share_mine_link}<td style='padding-left:5px;'><a href='#' class=\"comments-show-hide\">comments(#{comments ||= 0})</a></td></tr></table>"
  end

end
