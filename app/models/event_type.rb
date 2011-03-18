class EventType < ActiveRecord::Base
  GROUP_ACTIVITY_FEED = 10.freeze
  GROUP_NEWS_FEED     = 20.freeze

  GROUPS = {
    GROUP_ACTIVITY_FEED  => 'activity feed',
    GROUP_NEWS_FEED      => 'news feed'
  }
  
  has_many :activity_logs

  # #######
  # Group related methods
  # #######

  def status_name
    GROUPS[group]
  end

  # #######
  # Hardcoded methods returning particular EventTypes
  # 
  # NOTE: ID values of EventTypes are hardcoded. It's probably not the best solution,
  #       but at least it centralized here and not scattered all over the code.
  # #######
  def self.new_item_request_gifter(return_only_id = true)
    return_only_id ? 2 : EventType.find(2)
  end
  
  def new_item_request_gifter?
    self.id == EventType.new_item_request_gifter
  end

  def self.new_item_request_requester(return_only_id = true)
    return_only_id ? 3 : EventType.find(3)
  end

  def new_item_request_requester?
    self.id == EventType.new_item_request_requester
  end
end
