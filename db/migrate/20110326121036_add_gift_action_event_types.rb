class AddGiftActionEventTypes < ActiveRecord::Migration
 def self.up
    # insert activity feed gift related event types
    event_types = [
                    { :id => 27, :name => "ACCEPT GIFT RESPONSE GIFTER" },
                    { :id => 28, :name => "REJECT GIFT RESPONSE GIFTER" },
                    { :id => 29, :name => "ACCEPT GIFT RESPONSE REQUESTOR" },
                    { :id => 30, :name => "REJECT GIFT RESPONSE REQUESTOR" },
                    { :id => 31, :name => "REQUESTOR GIFT COMPLETED GIFTER" },
                    { :id => 32, :name => "REQUESTOR GIFT COMPLETED REQUESTOR" },
                    { :id => 33, :name => "GIFTER GIFT COMPLETED GIFTER" },
                    { :id => 34, :name => "GIFTER GIFT COMPLETED REQUESTOR" },
                    { :id => 35, :name => "GIFTER GIFT CANCEL GIFTER" },
                    { :id => 36, :name => "GIFTER GIFT CANCEL REQUESTOR" },
                    { :id => 37, :name => "REQUESTOR GIFT CANCEL GIFTER" },
                    { :id => 38, :name => "REQUESTOR GIFT CANCEL REQUESTOR" }
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
