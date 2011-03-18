class CreateEventTypes < ActiveRecord::Migration
  def self.up
    create_table :event_types do |t|
      t.string :name
      t.integer :group

      t.timestamps
    end
    
    # add event_type_id to activity_log
    add_column :activity_logs, :event_type_id, :integer

    # insert default event types
    event_type_names = [
                          "ADD ITEM",
                          "NEW ITEM REQUEST GIFTER",
                          "NEW ITEM REQUEST REQUESTER",
                          "ACCEPT RESPONSE GIFTER",
                          "REJECT RESPONSE GIFTER",
                          "ACCEPT RESPONSE REQUESTER",
                          "REJECT RESPONSE REQUESTER",
                          "COLLECTED GIFTER",
                          "COLLECTED REQUESTER",
                          "REQUESTER COMPLETED GIFTER",
                          "REQUESTER COMPLETED REQUESTER",
                          "GIFTER COMPLETED GIFTER",
                          "GIFTER COMPLETED REQUESTER",
                          "GIFTER CANCEL GIFTER",
                          "GIFTER CANCEL REQUESTER",
                          "REQUESTER CANCEL GIFTER",
                          "REQUESTER CANCEL REQUESTER"
                        ]

    event_type_names.each do |event_type_name|
      EventType.create!(:name => event_type_name, :group => EventType::GROUP_ACTIVITY_FEED)
    end
  end

  def self.down
    remove_column :activity_logs, :event_type_id
    drop_table :event_types
  end
end
