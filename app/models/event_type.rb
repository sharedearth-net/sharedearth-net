class EventType < ActiveRecord::Base
  GROUP_ACTIVITY_FEED = 10.freeze
  GROUP_NEWS_FEED     = 20.freeze

  GROUPS = {
    GROUP_ACTIVITY_FEED  => 'activity feed',
    GROUP_NEWS_FEED      => 'news feed'
  }
  
  has_many :activity_logs
  has_many :event_logs

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

  # "ADD ITEM", # 1
  # "NEW ITEM REQUEST GIFTER", # 2
  # "NEW ITEM REQUEST REQUESTER", # 3
  # "ACCEPT RESPONSE GIFTER", # 4
  # "REJECT RESPONSE GIFTER", # 5
  # "ACCEPT RESPONSE REQUESTER", # 6
  # "REJECT RESPONSE REQUESTER", # 7
  # "COLLECTED GIFTER", # 8
  # "COLLECTED REQUESTER", # 9
  # "REQUESTER COMPLETED GIFTER", # 10
  # "REQUESTER COMPLETED REQUESTER", # 11
  # "GIFTER COMPLETED GIFTER", # 12
  # "GIFTER COMPLETED REQUESTER", # 13
  # "GIFTER CANCEL GIFTER", # 14
  # "GIFTER CANCEL REQUESTER", # 15
  # "REQUESTER CANCEL GIFTER", # 16
  # "REQUESTER CANCEL REQUESTER" # 17

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
  
  # continuing with types for news feed
  #   { :id => 18, :name => "SHARING" },
  #   { :id => 19, :name => "ADD ITEM" },
  #   { :id => 20, :name => "NEGATIVE FEEDBACK" },
  #   { :id => 21, :name => "GIFTING" },
  #   { :id => 22, :name => "TRUST ESTABLISHED" },
  #   { :id => 23, :name => "TRUST WITHDRAWN" },
  #   { :id => 24, :name => "ITEM DAMAGED" },
  #   { :id => 25, :name => "ITEM REPAIRED" },
  #   { :id => 26, :name => "FB FRIEND JOIN" }

  def self.trust_established(return_only_id = true)
    return_only_id ? 22 : EventType.find(22)
  end
  
  def trust_established?
    self.id == EventType.trust_established
  end
end
