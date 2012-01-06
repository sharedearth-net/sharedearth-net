class AddEventTypeCommentRequest < ActiveRecord::Migration
  def self.up
    event_types = [
                          {:id => 63, :name => "REQUESTER COMMENTED GIFTER"}, # 63
                          {:id => 64, :name => "GIFTER COMMENTED REQUESTER"} # 64
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
