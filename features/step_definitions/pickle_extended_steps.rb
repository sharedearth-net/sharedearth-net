Given /^"(.*)" is the owner of item with name "(.*)"$/ do |name, item|
    person = Person.find_by_name("#{name}")
    Factory(:item, :owner => person, :name => item)
end

Given /^"(.*)" is the owner of hidden item with name "(.*)"$/ do |name, item|
    person = Person.find_by_name("#{name}")
    Factory(:item, :owner => person, :name => item, :hidden => true)
end

Given /^I am the owner of item with name "(.*)"$/ do |item|
    person = Person.find_by_name("John")
    Factory(:item, :owner => person, :name => item)
end

Given /^I am the owner of shareage item with name "([^"]*)"$/ do |item|
    person = Person.find_by_name("John")
    Factory(:item, :owner => person, :name => item, :purpose => Item::PURPOSE_SHAREAGE)
end

Given /^I am the owner of gift item with name "([^"]*)"$/ do |item|
    person = Person.find_by_name("John")
    Factory(:item, :owner => person, :name => item, :purpose => Item::PURPOSE_GIFT)
end

Given /^"(.*)" is the owner of shareage item with name "(.*)"$/ do |name, item|
    person = Person.find_by_name("#{name}")
    Factory(:item, :owner => person, :name => item, :purpose => Item::PURPOSE_SHAREAGE)
end

Given /^"(.*)" is the owner of gift item with name "(.*)"$/ do |name, item|
    person = Person.find_by_name("#{name}")
    Factory(:item, :owner => person, :name => item, :purpose => Item::PURPOSE_GIFT)
end


Given /^"(.*)" requested item with name "(.*)" from "(.*)"$/ do |person1,item, person2|
    person1 = Person.find_by_name("#{person1}")
    person2 = Person.find_by_name("#{person2}")
    item = Item.find_by_name("#{item}")
    @item_request = Factory(:item_request, :requester => person1, :gifter => person2, :item => item)
end

Given /^I requested item with name "(.*)" from person with name "(.*)"$/ do |item, person|
    person = Person.find_by_name("#{person}")
    me = Person.find_by_name("John")
    item = Item.find_by_name("#{item}")
    @item_request = Factory(:item_request, :requester => me, :gifter => person, :item => item)
end

Given /^Person with name "(.*)" has (completed|accepted|canceled) request with "(.*)"$/ do |person1, status, person2|
		case status
      when "completed"
        status_name = ItemRequest::STATUS_COMPLETED
      when "accepted"
        status_name = ItemRequest::STATUS_ACCEPTED
      when "canceled"
        status_name = ItemRequest::STATUS_CANCELED
    end
    person1 = Person.find_by_name("#{person1}")
    person2 = Person.find_by_name("#{person2}")
    item = Factory(:item, :owner => person1) 
    @item_request = Factory(:item_request, :requester => person2, :gifter => person1, :item => item, :status => status_name)
    Factory(:event_log, :primary => person2, :secondary => person1, :action_object => item, :related => @item_request )
end

Given /^Person with name "(.*)" has (completed|accepted|canceled) shareage request with "(.*)"$/ do |person1, status, person2|
		case status
      when "completed"
        status_name = ItemRequest::STATUS_COMPLETED
      when "accepted"
        status_name = ItemRequest::STATUS_ACCEPTED
      when "canceled"
        status_name = ItemRequest::STATUS_CANCELED
    end
    person1 = Person.find_by_name("#{person1}")
    person2 = Person.find_by_name("#{person2}")
    item = Factory(:item, :owner => person1, :purpose => Item::PURPOSE_SHAREAGE) 
    @item_request = Factory(:item_request, :requester => person2, :gifter => person1, :item => item, :status => status_name)
    Factory(:event_log, :primary => person2, :secondary => person1, :action_object => item, :related => @item_request )
end

Given /^I am looking at last request page$/ do
  visit request_path(@item_request)
end

Then /^Last request is accepted$/ do
  @item_request.accept!
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
    Factory(:human_network, :entity_id => person1.id, :entity_type => "Person", :human_id => person2.id)
    Factory(:human_network, :entity_id => person2.id, :entity_type => "Person", :human_id => person1.id)
end

Given /^I delete (.+)$/ do |model_name|
  model(model_name).delete
end

Given /^"(.*)" deletes item "(.*)"$/ do |name, item_name|
  person = Person.find_by_name("#{name}")
  item = Item.find_by_owner_id_and_name(person.id, "#{item_name}")
  item.delete
end

Given /^"(.*)" (completed|accepted|canceled) item request with "(.*)" for item "(.*)"$/ do |person_1, status, person_2, item|
		case status
      when "completed"
        status_name = ItemRequest::STATUS_COMPLETED
      when "accepted"
        status_name = ItemRequest::STATUS_ACCEPTED
      when "canceled"
        status_name = ItemRequest::STATUS_CANCELED
    end
    person_1 = Person.find_by_name("#{person_1}")
    person_2 = Person.find_by_name("#{person_2}")
    item = Item.find_by_name("#{item}")
    @item_request = Factory(:item_request, :requester => person_1, :gifter => person_2, :item => item, :status => status_name)
end

Given /^"(.*)" left comment "(.*)" for last request$/ do |person, comment|
    person = Person.find_by_name("#{person}")
    Factory(:comment, :commentable => @item_request, :user_id => person.user.id, :comment => comment)
end
