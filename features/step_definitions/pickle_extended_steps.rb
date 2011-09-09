Given /^"(.*)" is the owner of item with name "(.*)"$/ do |name, item|
    person = Person.find_by_name("#{name}")
    Factory(:item, :owner => person, :name => item)
end

Given /^I am the owner of item with name "(.*)"$/ do |item|
    person = Person.find_by_name("John")
    Factory(:item, :owner => person, :name => item)
end

Given /^"(.*)" requested item with name "(.*)" from "(.*)"$/ do |person1,item, person2|
    person1 = Person.find_by_name("#{person1}")
    person2 = Person.find_by_name("#{person2}")
    item = Item.find_by_name("#{item}")
       Factory(:item_request, :requester => person1, :gifter => person2, :item => item)
end

Given /^I requested item with name "(.*)" from person with name "(.*)"$/ do |item, person|
    person = Person.find_by_name("#{person}")
    me = Person.find_by_name("John")
    item = Item.find_by_name("#{item}")
    Factory(:item_request, :requester => me, :gifter => person, :item => item)
end

Given /^Person with name "(.*)" has completed request with "(.*)"$/ do |person1, person2|
    person1 = Person.find_by_name("#{person1}")
    person2 = Person.find_by_name("#{person2}")
    item = Factory(:item, :owner => person1) 
    @item_request = Factory(:item_request, :requester => person2, :gifter => person1, :item => item, :status => ItemRequest::STATUS_COMPLETED)
    Factory(:event_log, :primary => person2, :secondary => person1, :action_object => item, :related => @item_request )
end

Given /^I am looking at last request page$/ do
  visit request_path(@item_request)
end

Given /^invitation key exsists$/ do
  me = Person.find_by_name("John")
  Factory(:invitation, :inviter_person_id => me.id)
end

Given /^Person with name "(.*)" left (positive|negative|neutral) feedback for last request$/ do |person,feedback|
    case feedback
      when "positive"
        feed = Feedback::FEEDBACK_POSITIVE
      when "negative"
        feed = Feedback::FEEDBACK_NEGATIVE
        note = "Negative opinion"
      when "neutral"
        feed = Feedback::FEEDBACK_NEUTRAL
        note = "Neutral opinion"
    end
    person = Person.find_by_name("#{person}")
    Factory(:feedback, :person => person, :item_request_id => @item_request.id, :feedback => feed, :feedback_note => note)
end

Given /^"(.*)" has trusted relationship with "(.*)"$/ do |person1, person2|
    person1 = Person.find_by_name("#{person1}")
    person2 = Person.find_by_name("#{person2}")
    Factory(:people_network, :person_id => person1.id, :trusted_person_id => person2.id, :entity_id => person2.id)
    Factory(:people_network, :person_id => person2.id, :trusted_person_id => person1.id, :entity_id => person1.id)
end

Given /^I delete (.+)$/ do |model_name|
  model(model_name).delete
end
