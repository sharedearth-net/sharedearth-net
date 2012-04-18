class AddAdditionalShareageEventTypes < ActiveRecord::Migration
  def self.up
   event_types = [
                          {:id => 71, :name => "COLLECTED SHAREAGE GIFTER"},
                          {:id => 72, :name => "COLLECTED SHAREAGE REQUESTER"},
                          {:id => 73, :name => "RETURN SHAREAGE GIFTER"},
                          {:id => 74, :name => "RETURN SHAREAGE REQUESTER"},
                          {:id => 75, :name => "RECALL SHAREAGE GIFTER"},
                          {:id => 76, :name => "RECALL SHAREAGE REQUESTER"},
                          {:id => 77, :name => "CANCEL RECALL SHAREAGE GIFTER"},
                          {:id => 78, :name => "CANCEL RECALL SHAREAGE REQUESTER"},
                          {:id => 79, :name => "ACKNOWLEDGE SHAREAGE GIFTER"},
                          {:id => 80, :name => "ACKNOWLEDGE SHAREAGE REQUESTER"},
                          {:id => 81, :name => "RETURNED SHAREAGE GIFTER"},
                          {:id => 82, :name => "RETURNED SHAREAGE REQUESTER"},
                          {:id => 83, :name => "CANCEL RETURN SHAREAGE GIFTER"},
                          {:id => 84, :name => "CANCEL RETURN SHAREAGE REQUESTER"}
                        ]

    event_types.each do |event_type|
      et = EventType.new(:name => event_type[:name], :group => EventType::GROUP_ACTIVITY_FEED)
      et.id = event_type[:id]
      et.save!
    end
  end

  def self.down
  end
end
