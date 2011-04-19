require 'spec_helper'
include PagesHelper
include PeopleHelper

module PagesSpecHelper

  def setup_pages_helper_environment
    user = Factory(:user)
    @person = Factory(:person, :user => user)
    @item = Factory(:item, :owner => @person)
    @activity_log = Factory(:activity_log, :event_type_id => 1, :secondary_id => @person, :action_object_id => @item)
  end

end

# Specs in this file have access to a helper object that includes
# the PagesHelper. For example:
#
# describe PagesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end

describe PagesHelper, "When printing activity log sentances" do

  include PagesSpecHelper

  before(:all) do
    setup_pages_helper_environment
    @item_link = "<a href=\"/items/#{@item.id}\" class=\"positive\">#{@item.item_type}</a>"
    @person_link = "<a href=\"/people/#{@activity_log.secondary_id}\" class=\"positive\">#{@activity_log.secondary_short_name}</a>"
    @person_full_link = "<a href=\"/people/#{@activity_log.secondary_id}\" class=\"positive\">#{@activity_log.secondary_full_name}</a>"
    @person_possesive_link =  "<a href=\"/people/#{@activity_log.secondary_id}\" class=\"positive\">#{@activity_log.secondary_short_name}'s</a>"
  end

  it "should generate sentace for ADD ITEM event type" do
    @activity_log.event_type_id = 1  
    html = recent_activity_sentance(@activity_log)
    html.should == "You are now sharing your #{@item_link}"
  end
  
  it "should generate sentace for NEW ITEM REQUEST GIFTER event type" do
    @activity_log.event_type_id = 2  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} made a request to borrow your #{@item_link}"
  end
  
  it "should generate sentace for NEW ITEM REQUEST REQUESTER event type" do
    @activity_log.event_type_id = 3  
    html = recent_activity_sentance(@activity_log)
    html.should == "You made a request to borrow #{@person_possesive_link} #{@item_link}"
  end
  
  it "should generate sentace for ACCEPT RESPONSE GIFTER event type" do
    @activity_log.event_type_id = 4  
    html = recent_activity_sentance(@activity_log)
    html.should == "You accepted #{@person_possesive_link} request to borrow your #{@item_link}"
  end
  
  it "should generate sentace for REJECT RESPONSE GIFTER event type" do
    @activity_log.event_type_id = 5  
    html = recent_activity_sentance(@activity_log)
    html.should == "You rejected #{@person_possesive_link} request to borrow your #{@item_link}"
  end
  
  it "should generate sentace for ACCEPT RESPONSE REQUESTER event type" do
    @activity_log.event_type_id = 6  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} accepted your request to borrow their #{@item_link}"
  end
  
    it "should generate sentace for REJECT RESPONSE REQUESTER event type" do
    @activity_log.event_type_id = 7  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} rejected your request to borrow their #{@item_link}"
  end
  
  it "should generate sentace for COLLECTED GIFTER event type" do
    @activity_log.event_type_id = 8  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} collected your #{@item_link}"
  end
  
  it "should generate sentace for COLLECTED REQUESTER event type" do
    @activity_log.event_type_id = 9  
    html = recent_activity_sentance(@activity_log)
    html.should == "You collected #{@person_possesive_link} #{@item_link}"
  end
  
  it "should generate sentace for REQUESTER COMPLETED GIFTER event type" do
    @activity_log.event_type_id = 10  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} completed the action borrowing your #{@item_link}"
  end
  
    it "should generate sentace for REQUESTER COMPLETED REQUESTER event type" do
    @activity_log.event_type_id = 11  
    html = recent_activity_sentance(@activity_log)
    html.should == "You completed the action of borrowing #{@person_possesive_link} #{@item_link}"
  end
  
  it "should generate sentace for GIFTER COMPLETED GIFTER event type" do
    @activity_log.event_type_id = 12  
    html = recent_activity_sentance(@activity_log)
    html.should == "You completed the action of sharing your #{@item_link} with #{@person_link}"
  end
  
  it "should generate sentace for GIFTER COMPLETED REQUESTER event type" do
    @activity_log.event_type_id = 13  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} completed the action sharing their #{@item_link} with you "
  end
  
  it "should generate sentace for GIFTER CANCEL GIFTER event type" do
    @activity_log.event_type_id = 14  
    html = recent_activity_sentance(@activity_log)
    html.should == "You canceled the action sharing your #{@item_link}" + " with #{@person_link}"
  end
  
    it "should generate sentace for GIFTER CANCEL REQUESTER event type" do
    @activity_log.event_type_id = 15  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} canceled the action sharing their #{@item_link} with you "
  end
  
  it "should generate sentace for REQUESTER CANCEL GIFTER event type" do
    @activity_log.event_type_id = 16  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} canceled the request to borrow your #{@item_link}"
  end
  
  it "should generate sentace for REQUESTER CANCEL REQUESTER event type" do
    @activity_log.event_type_id = 17  
    html = recent_activity_sentance(@activity_log)
    html.should == "You canceled the request to borrow #{@person_possesive_link} #{@item_link}"
  end
  
  
  
  
  
  
  
  it "should generate sentace for SHARING event type" do
    @activity_log.event_type_id = 18  
    html = recent_activity_sentance(@activity_log)
    html.should == ""
  end
  
  it "should generate sentace for ADD ITEM event type" do
    @activity_log.event_type_id = 19  
    html = recent_activity_sentance(@activity_log)
    html.should == "You are now sharing your #{@item_link}"
  end
  
  it "should generate sentace for NEGATIVE FEEDBACK event type" do
    @activity_log.event_type_id = 20 
    html = recent_activity_sentance(@activity_log)
    html.should == ""
  end
  
  it "should generate sentace for GIFTING event type" do
    @activity_log.event_type_id = 21  
    html = recent_activity_sentance(@activity_log)
    html.should == ""
  end
  
  it "should generate sentace for TRUST ESTABLISHED event type" do
    @activity_log.event_type_id = 22  
    html = recent_activity_sentance(@activity_log)
    html.should == ""
  end
  
  it "should generate sentace for TRUST WITHDRAWN event type" do
    @activity_log.event_type_id = 23  
    html = recent_activity_sentance(@activity_log)
    html.should == ""
  end
  
  it "should generate sentace for ITEM DAMAGED event type" do
    @activity_log.event_type_id = 24  
    html = recent_activity_sentance(@activity_log)
    html.should == "Your #{@item_link} is damaged!"
  end
  
  it "should generate sentace for ITEM REPAIRED event type" do
    @activity_log.event_type_id = 25  
    html = recent_activity_sentance(@activity_log)
    html.should == "Your #{@item_link} is repaired!"
  end
  
  it "should generate sentace for FB FRIEND JOIN event type" do
    @activity_log.event_type_id = 26  
    html = recent_activity_sentance(@activity_log)
    html.should == ""
  end
  
  
  
  
  

  
  
  it "should generate sentace for ACCEPT GIFT RESPONSE GIFTER event type" do
    @activity_log.event_type_id = 27  
    html = recent_activity_sentance(@activity_log)
    html.should == "You accepted #{@person_possesive_link} request for your #{@item_link}"
  end
  
  it "should generate sentace for REJECT GIFT RESPONSE GIFTER event type" do
    @activity_log.event_type_id = 28  
    html = recent_activity_sentance(@activity_log)
    html.should == "You rejected #{@person_possesive_link} request for your #{@item_link}"
  end
  
  it "should generate sentace for ACCEPT GIFT RESPONSE REQUESTOR event type" do
    @activity_log.event_type_id = 29  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} accepted your request for their #{@item_link}"
  end
  
  it "should generate sentace for REJECT GIFT RESPONSE REQUESTOR event type" do
    @activity_log.event_type_id = 30  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} rejected your request for their #{@item_link}"
  end
  
  it "should generate sentace for REQUESTOR GIFT COMPLETED GIFTER event type" do
    @activity_log.event_type_id = 31  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} completed the action of receiving your #{@item_link}"
  end
  
  it "should generate sentace for REQUESTOR GIFT COMPLETED REQUESTOR event type" do
    @activity_log.event_type_id = 32 
    html = recent_activity_sentance(@activity_log)
    html.should == "You completed the action of receiving #{@person_possesive_link}" + " #{@item_link}"
  end
  
  it "should generate sentace for GIFTER GIFT COMPLETED GIFTER event type" do
    @activity_log.event_type_id = 33  
    html = recent_activity_sentance(@activity_log)
    html.should == "You completed the action of gifting your #{@item_link} to #{@person_link}"
  end
  
  it "should generate sentace for GIFTER GIFT COMPLETED REQUESTOR event type" do
    @activity_log.event_type_id = 34  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} completed the action of gifting their #{@item_link} to you"
  end
  
  it "should generate sentace for GIFTER GIFT CANCEL GIFTER event type" do
    @activity_log.event_type_id = 35  
    html = recent_activity_sentance(@activity_log)
    html.should == "You canceled the action of gifting your #{@item_link} to #{@person_link}"
  end
  
  it "should generate sentace for GIFTER GIFT CANCEL REQUESTOR event type" do
    @activity_log.event_type_id = 36  
    html = recent_activity_sentance(@activity_log)
    html.should ==  "#{@person_link} canceled the action of gifting their #{@item_link} to you"
  end
  
  it "should generate sentace for REQUESTOR GIFT CANCEL GIFTER event type" do
    @activity_log.event_type_id = 37  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} canceled the request for your #{@item_link}"
  end
  
  it "should generate sentace for REQUESTOR GIFT CANCEL REQUESTOR event type" do
    @activity_log.event_type_id = 38  
    html = recent_activity_sentance(@activity_log)
    html.should == "You cancelled the request for #{@person_possesive_link}" + " #{@item_link}"
  end
  
  
  
  
  
  
  
  it "should generate sentace for NEW ITEM REQUEST GIFTER event type" do
    @activity_log.event_type_id = 39  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} made a request to borrow your #{@item_link}" 
  end
  
  it "should generate sentace for NEW ITEM REQUEST REQUESTOR event type" do
    @activity_log.event_type_id = 40  
    html = recent_activity_sentance(@activity_log)
    html.should == "You made a request to borrow #{@person_possesive_link} #{@item_link}"
  end
  
  it "should generate sentace for TRUST ESTABLISHED INITIATOR event type" do
    @activity_log.event_type_id = 41  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} confirmed you have a trusted relationship with them"
  end
  
  it "should generate sentace for TRUST ESTABLISHED OTHER PARTY event type" do
    @activity_log.event_type_id = 42  
    html = recent_activity_sentance(@activity_log)
    html.should == "You confirmed you have a trusted relationship with #{@person_link}"
  end
  
  it "should generate sentace for TRUST DENIED INITIATOR event type" do
    @activity_log.event_type_id = 43  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} denied you have a trusted relationship with them"
  end
  
  it "should generate sentace for TRUST DENIED OTHER PARTY event type" do
    @activity_log.event_type_id = 44 
    html = recent_activity_sentance(@activity_log)
    html.should == "You denied you have a trusted relationship with #{@person_link}"
  end
  
  it "should generate sentace for TRUST WITHDRAWN INITIATOR event type" do
    @activity_log.event_type_id = 45
    html = recent_activity_sentance(@activity_log)
    html.should == "You have withdrawn your trust for #{@person_link}"
  end
  
  it "should generate sentace for TRUST WITHDRAWN OTHER PARTY event type" do
    @activity_log.event_type_id = 46  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} has withdrawn their trust for you"
  end
  
  it "should generate sentace for TRUST CANCEL INITIATOR event type" do
    @activity_log.event_type_id = 47 
    html = recent_activity_sentance(@activity_log)
    html.should == "You cancelled the establishment of a trusted relationship with #{@person_link}"
  end
  
  it "should generate sentace for TRUST CANCEL OTHER PARTY event type" do
    @activity_log.event_type_id = 48  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} cancelled the establishment of a trusted relationship with you"
  end
  
  it "should generate sentace for ITEM LOST event type" do
    @activity_log.event_type_id = 49 
    html = recent_activity_sentance(@activity_log)
    html.should == "You lost your #{@item_link}!"
  end
  
  it "should generate sentace for ITEM FOUND event type" do
    @activity_log.event_type_id = 50  
    html = recent_activity_sentance(@activity_log)
    html.should == "You found your #{@item_link}!"
  end
  
  it "should generate sentace for ITEM DAMAGED event type" do
    @activity_log.event_type_id = 51  
    html = recent_activity_sentance(@activity_log)
    html.should == "Your #{@item_link}is damaged!" 
  end
  
  it "should generate sentace for ITEM REPAIRED event type" do
    @activity_log.event_type_id = 52  
    html = recent_activity_sentance(@activity_log)
    html.should ==  "Your #{@item_link} is repaired!"
  end
  
  it "should generate sentace for ITEM REMOVED event type" do
    @activity_log.event_type_id = 53  
    html = recent_activity_sentance(@activity_log)
    html.should == "You removed your #{@item_link} from sharedearth.net"
  end
  
  it "should generate sentace for PERSON JOIN event type" do
    @activity_log.event_type_id = 54
    html = recent_activity_sentance(@activity_log)
    html.should == "You connected to sharedearth.net"
  end
  
  it "should generate sentace for POSITIVE FEEDBACK GIFTER event type" do
    @activity_log.event_type_id = 55  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} has left you positive feedback after borrowing your #{@item_link}"
  end
  
  it "should generate sentace for POSITIVE FEEDBACK REQUESTOR event type" do
    @activity_log.event_type_id = 56  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} has left you positive feedback after sharing their #{@item_link} with you"
  end
  
  it "should generate sentace for NEGATIVE FEEDBACK GIFTER event type" do
    @activity_log.event_type_id = 57 
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} has left you negative feedback after borrowing your #{@item_link}"
  end
  
  it "should generate sentace for NEGATIVE FEEDBACK REQUESTOR event type" do
    @activity_log.event_type_id = 58  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} has left you negative feedback after sharing their #{@item_link} with you"
  end
  
  it "should generate sentace for NEUTRAL FEEDBACK GIFTER event type" do
    @activity_log.event_type_id = 59  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} has left you neutral feedback after borrowing your #{@item_link}"
  end
  
  it "should generate sentace for NEUTRAL FEEDBACK REQUESTOR event type" do
    @activity_log.event_type_id = 60  
    html = recent_activity_sentance(@activity_log)
    html.should == "#{@person_link} has left you neutral feedback after sharing their #{@item_link} with you"
  end

  
  
  
  
  
  
  
  
  #pending "TODO add test for recent_activity_sentance "
end

describe PagesHelper, "When printing event log sentances" do

  it "should generate sentace for add item sentence" do
    #TODO
  end
  
  it "should generate sentace for sharing sentence" do
    #TODO
  end
  
  it "should generate sentace for gifting sentence" do
    #TODO
  end
  
  it "should generate sentace for trust established sentence" do
    #TODO
  end
  
  it "should generate sentace for trust withdrawn sentence" do
    #TODO
  end
  
  it "should generate sentace for item repaired sentence" do
    #TODO
  end
  
  it "should generate sentace for fb friend join sentence" do
    #TODO
  end
  

end

describe PagesHelper, "When printing avatar for activity log event" do

  it "should generate sentace for recent activit avatar" do
    #TODO
  end
end




