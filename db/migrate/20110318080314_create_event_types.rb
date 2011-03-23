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
                          "ADD ITEM", # 1
                          "NEW ITEM REQUEST GIFTER", # 2
                          "NEW ITEM REQUEST REQUESTER", # 3
                          "ACCEPT RESPONSE GIFTER", # 4
                          "REJECT RESPONSE GIFTER", # 5
                          "ACCEPT RESPONSE REQUESTER", # 6
                          "REJECT RESPONSE REQUESTER", # 7
                          "COLLECTED GIFTER", # 8
                          "COLLECTED REQUESTER", # 9
                          "REQUESTER COMPLETED GIFTER", # 10
                          "REQUESTER COMPLETED REQUESTER", # 11
                          "GIFTER COMPLETED GIFTER", # 12
                          "GIFTER COMPLETED REQUESTER", # 13
                          "GIFTER CANCEL GIFTER", # 14
                          "GIFTER CANCEL REQUESTER", # 15
                          "REQUESTER CANCEL GIFTER", # 16
                          "REQUESTER CANCEL REQUESTER" # 17
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
