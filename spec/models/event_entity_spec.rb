require 'spec_helper'

describe EventEntity do
  describe "recent_events_for" do
    it "should provide recent activity of person" do
      person = Factory :person
      user = Factory :person
      some_entity = Factory :event_entity
      event_entity = Factory :event_entity, :entity_id => person.id
      
      Factory :human_network, :person => user, :entity_id => event_entity.entity_id , :entity_type => event_entity.entity_type
      
      recent_events = EventEntity.recent_events_for user
      recent_events.count.should == 1
      recent_events.first.event_log_id.should == event_entity.event_log_id
    end
  end
  
  describe "self.create_for_related_groups" do
    it "should create event entity for all groups of a person" do
      person = Factory :person
      village_1 = Factory :village 
      village_2 = Factory :village 
      event_log = Factory :event_log
      
      network_1 = Factory :village_network, :person => person, :entity => village_1
      network_2 = Factory :village_network, :person => person, :entity => village_2
      
      EventEntity.create_for_related_groups person, event_log     
      EventEntity.all.count.should == 2
      
      event_entity_1 = EventEntity.first
      event_entity_1.entity_id.should == village_1.id
      event_entity_1.entity_type.should == "Village"
      event_entity_1.event_log.should == event_log
    end   
  end
end
