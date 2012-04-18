class AddNewShareageEventTypes < ActiveRecord::Migration
  def self.up
event_types = [
                          {:id => 86, :name => "GIFTER CANCEL SHAREAGE GIFTER"},
                          {:id => 87, :name => "GIFTER CANCEL SHAREAGE REQUESTER"},
                          {:id => 88, :name => "REQUESTER CANCEL SHAREAGE GIFTER"},
                          {:id => 89, :name => "REQUESTER CANCEL SHAREAGE REQUESTER"},
                          {:id => 90, :name => "ACKNOWLEDGE RETURN SHAREAGE GIFTER"},
                          {:id => 91, :name => "ACKNOWLEDGE RETURN SHAREAGE REQUESTER"}
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
