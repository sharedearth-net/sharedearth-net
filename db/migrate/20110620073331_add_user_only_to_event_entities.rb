class AddUserOnlyToEventEntities < ActiveRecord::Migration
  def self.up
    add_column :event_entities, :user_only, :boolean, :default => false
    events = EventEntity.all
    events.each do |e|
      #IF EQUAL TO EVENT NUMBER 26 - FB FRIEND JOIN
      if e.event_log.event_type_id == 26 
        e.user_only = true
        e.save!
      end
    end
  end

  def self.down
    remove_column :event_entities, :user_only
  end
end
