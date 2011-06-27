class AddNewEventType < ActiveRecord::Migration
  def self.up
    # insert news feed related event types
    event_types = [
                    { :id => 39, :name => "PERSON JOIN" }
                  ]

    event_types.each do |event_type|
      et = EventType.new(:name => event_type[:name], :group => EventType::GROUP_NEWS_FEED)
      et.id = event_type[:id]
      et.save!
    end
  end

  def self.down
  end
end
