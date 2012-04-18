class AddEventTypeShareage < ActiveRecord::Migration
  def self.up
    event_types = [
                          {:id => 65, :name => "SHAREAGE REQUEST GIFTER"}, # 65
                          {:id => 66, :name => "SHAREAGE REQUEST REQUESTER"}, # 66
                          {:id => 67, :name => "ACCEPT SHAREAGE GIFTER"}, # 67
                          {:id => 68, :name => "REJECT SHAREAGE GIFTER"}, # 68
                          {:id => 69, :name => "ACCEPT SHAREAGE REQUESTER"}, # 69
                          {:id => 70, :name => "REJECT SHAREAGE REQUESTER"} # 70

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
