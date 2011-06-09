class EventDisplay < ActiveRecord::Base
  # t.integer :type_id - id for which page or entity event log is generated
  # t.integer  :person_id - id of person to whom the event log was displayed
  # t.integer :event_id - id of the event that was shown to the person
  DASHBOARD_FEED = 10.freeze
  RECENT_ACTIVITY_FEED = 20.freeze
  
  belongs_to :event_log
end
