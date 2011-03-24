class AddNewsFeedEventTypes < ActiveRecord::Migration
  def self.up
    # insert news feed related event types
    event_types = [
                    { :id => 18, :name => "SHARING" },
                    { :id => 19, :name => "ADD ITEM" },
                    { :id => 20, :name => "NEGATIVE FEEDBACK" },
                    { :id => 21, :name => "GIFTING" },
                    { :id => 22, :name => "TRUST ESTABLISHED" },
                    { :id => 23, :name => "TRUST WITHDRAWN" },
                    { :id => 24, :name => "ITEM DAMAGED" },
                    { :id => 25, :name => "ITEM REPAIRED" },
                    { :id => 26, :name => "FB FRIEND JOIN" }
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
