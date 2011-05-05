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
  
  #ACCEPTED REQUESTS
  
  def self.item_request_accepted_gifter(return_only_id = true)
    return_only_id ? 4 : EventType.find(4)
  end
  
  def item_request_accepted_gifter?
    self.id == EventType.item_request_accepted_gifter
  end
  
  def self.item_request_accepted_requester(return_only_id = true)
    return_only_id ? 6 : EventType.find(6)
  end

  def item_request_accepted_requester?
    self.id == EventType.item_request_accepted_requester
  end

  #REJECTED REQUESTS
    
  def self.item_request_rejected_gifter(return_only_id = true)
    return_only_id ? 5 : EventType.find(5)
  end
  
  def item_request_rejected_gifter?
    self.id == EventType.item_request_rejected_gifter
  end
  
  def self.item_request_rejected_requester(return_only_id = true)
    return_only_id ? 7 : EventType.find(7)
  end

  def item_request_rejected_requester?
    self.id == EventType.item_request_rejected_requester
  end
  
  #CANCELED REQUESTS
  
  def self.item_gifter_canceled_gifter(return_only_id = true)
    return_only_id ? 14 : EventType.find(14)
  end

  def item_gifter_canceled_gifter?
    self.id == EventType.item_request_canceled_gifter
  end
  
  def self.item_gifter_canceled_requester(return_only_id = true)
    return_only_id ? 15 : EventType.find(15)
  end

  def item_gifter_canceled_requester?
    self.id == EventType.item_gifter_canceled_requester
  end
  
  def self.item_requester_canceled_gifter(return_only_id = true)
    return_only_id ? 16 : EventType.find(16)
  end

  def item_requester_canceled_gifter?
    self.id == EventType.item_requester_canceled_gifter
  end
  
  def self.item_requester_canceled_requester(return_only_id = true)
    return_only_id ? 17 : EventType.find(17)
  end

  def item_requester_canceled_requester?
    self.id == EventType.item_requester_canceled_requester
  end
  
  #COLLECTED REQUESTS
  
  def self.item_request_collected_gifter(return_only_id = true)
    return_only_id ? 8 : EventType.find(8)
  end

  def item_request_collected_gifter?
    self.id == EventType.item_request_collected_gifter
  end
  
  def self.item_request_collected_requester(return_only_id = true)
    return_only_id ? 9 : EventType.find(9)
  end

  def item_request_collected_requester?
    self.id == EventType.item_request_collected_requester
  end
  
  #COMPLETED REQUESTS
  
  def self.item_request_completed_gifter(return_only_id = true)
    return_only_id ? 10 : EventType.find(10)
  end

  def item_request_completed_gifter?
    self.id == EventType.item_request_completed_gifter
  end
  
  def self.item_request_completed_requester(return_only_id = true)
    return_only_id ? 11 : EventType.find(11)
  end

  def item_request_completed_requester?
    self.id == EventType.item_request_completed_requester
  end
  
  def self.item_gifter_completed_gifter(return_only_id = true)
    return_only_id ? 12 : EventType.find(12)
  end

  def item_gifter_completed_gifter?
    self.id == EventType.item_gifter_completed_gifter
  end
  
  def self.item_gifter_completed_requester(return_only_id = true)
    return_only_id ? 13 : EventType.find(13)
  end

  def item_gifter_collected_requester?
    self.id == EventType.item_request_completed_requester
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
  def self.sharing(return_only_id = true)
    return_only_id ? 18 : EventType.find(18)
  end
  
  def sharing?
    self.id == EventType.sharing
  end
  
  def self.add_item(return_only_id = true)
    return_only_id ? 19 : EventType.find(19)
  end
  
  def add_item?
    self.id == EventType.add_item
  end
  
  def self.negative_feedback(return_only_id = true)
    return_only_id ? 20 : EventType.find(20)
  end
  
  def negative_feedback?
    self.id == EventType.negative_feedback
  end
  
  def self.gifting(return_only_id = true)
    return_only_id ? 21 : EventType.find(21)
  end
  
  def gifting?
    self.id == EventType.gifting
  end
  
  def self.trust_withdrawn(return_only_id = true)
    return_only_id ? 23 : EventType.find(23)
  end
  
  def trust_withdrawn?
    self.id == EventType.trust_withdrawn
  end
  
  def self.item_damaged(return_only_id = true)
    return_only_id ? 24 : EventType.find(24)
  end
  
  def item_damaged?
    self.id == EventType.item_damaged
  end
  
  def self.item_repaired(return_only_id = true)
    return_only_id ? 25 : EventType.find(25)
  end
  
  def item_repaired?
    self.id == EventType.item_repaired
  end
  
  def self.fb_friend_join(return_only_id = true)
    return_only_id ? 26 : EventType.find(26)
  end
  
  def fb_friend_join?
    self.id == EventType.fb_friend_join
  end
  
  
  
  
  
  

  def self.trust_established(return_only_id = true)
    return_only_id ? 22 : EventType.find(22)
  end
  
  def trust_established?
    self.id == EventType.trust_established
  end
  
  #GIFTING EVENT TYPES
  
  def self.gift_accepted_gifter(return_only_id = true)
    return_only_id ? 27 : EventType.find(27)
  end

  def gift_accepted_gifter?
    self.id == EventType.gift_accepted_gifter
  end
  
  def self.gift_rejected_gifter(return_only_id = true)
    return_only_id ? 28 : EventType.find(28)
  end

  def gift_rejected_gifter?
    self.id == EventType.gift_rejected_gifter
  end
  
  def self.gift_accepted_requester(return_only_id = true)
    return_only_id ? 29 : EventType.find(29)
  end

  def gift_accepted_requester?
    self.id == EventType.gift_accepted_requester
  end
  
  def self.gift_rejected_requester(return_only_id = true)
    return_only_id ? 30 : EventType.find(30)
  end

  def gift_rejected_requester?
    self.id == EventType.gift_rejected_requester
  end
  
  def self.gift_requester_completed_gifter(return_only_id = true)
    return_only_id ? 31 : EventType.find(31)
  end

  def gift_requester_completed_gifter?
    self.id == EventType.gift_requester_completed_gifter
  end
  
    def self.gift_requester_completed_requester(return_only_id = true)
    return_only_id ? 32 : EventType.find(32)
  end

  def gift_requester_completed_requester?
    self.id == EventType.gift_requester_completed_requester
  end
  
  def self.gift_gifter_completed_gifter(return_only_id = true)
    return_only_id ? 33 : EventType.find(33)
  end

  def gift_gifter_completed_gifter?
    self.id == EventType.gift_gifter_completed_gifter
  end
  
    def self.gift_gifter_completed_requester(return_only_id = true)
    return_only_id ? 34 : EventType.find(34)
  end

  def gift_gifter_completed_requester?
    self.id == EventType.gift_gifter_completed_requester
  end
  
  def self.gift_gifter_canceled_gifter(return_only_id = true)
    return_only_id ? 35 : EventType.find(35)
  end

  def gift_gifter_canceled_gifter?
    self.id == EventType.gift_gifter_canceled_gifter
  end
  
    def self.gift_gifter_canceled_requester(return_only_id = true)
    return_only_id ? 36 : EventType.find(36)
  end

  def gift_gifter_canceled_requester?
    self.id == EventType.gift_gifter_canceled_requester
  end
  
    def self.gift_requester_canceled_gifter(return_only_id = true)
    return_only_id ? 37 : EventType.find(37)
  end

  def gift_requester_canceled_gifter?
    self.id == EventType.gift_requester_canceled_gifter
  end
  
  def self.gift_requester_canceled_requester(return_only_id = true)
    return_only_id ? 38 : EventType.find(38)
  end

  def gift_requester_canceled_requester?
    self.id == EventType.gift_requester_canceled_requester
  end
  
  
  def self.completed_request_ids
    [10,11,12,13,31,32,33,34]
  end
  
  def self.events_completed
    [18,19,21]
  end
  
  def self.activity_accepted
    [4,6,27,29]
  end
  
  def self.activity_canceled
    [17,38]
  end
  
  def self.personal_actions
    [1,3,4,5,9,11,12,14,17,27,28,32,33,35,38]
  end
  
  def self.personal_actions_objective
    [2,6,7,10,13,15,16,29,30,31,34,36,37]
  end
  
  def self.current_actions_underway
    [2,3,4,6,8,9,27,29]
  end
  
  def completed?
    self.item_request_completed_gifter? || self.item_request_completed_requester? || self.item_gifter_completed_gifter? || self.item_gifter_collected_requester?
  end
  
=begin
  
  def self.new_gift_item_request_gifter(return_only_id = true)
    return_only_id ? 39 : EventType.find(39)
  end

  def new_gift_item_request_gifter?
    self.id == EventType.new_item_request_gifter
  end
  
  def self.new_gift_item_request_requester(return_only_id = true)
    return_only_id ? 40 : EventType.find(40)
  end

  def new_item_gift_request_requester?
    self.id == EventType.new_item_request_requester
  end
  
  def self.trust_established_initiator(return_only_id = true)
    return_only_id ? 41 : EventType.find(41)
  end

  def trust_established_initiator?
    self.id == EventType.trust_established_initiator
  end
  
  def self.trust_established_other_party(return_only_id = true)
    return_only_id ? 42 : EventType.find(42)
  end

  def trust_established_other_party?
    self.id == EventType.trust_established_other_party
  end
  
  def self.trust_denied_initiator(return_only_id = true)
    return_only_id ? 43 : EventType.find(43)
  end

  def trust_denied_initiator?
    self.id == EventType.trust_denied_initiator
  end
  
  def self.trust_denied_other_party(return_only_id = true)
    return_only_id ? 44 : EventType.find(44)
  end

  def trust_denied_other_party?
    self.id == EventType.trust_denied_other_party
  end
  
  def self.trust_withdrawn_initiator(return_only_id = true)
    return_only_id ? 45 : EventType.find(45)
  end

  def trust_withdrawn_initiator?
    self.id == EventType.trust_withdrawn_initiator
  end
  
  def self.trust_withdrawn_other_party(return_only_id = true)
    return_only_id ? 46 : EventType.find(46)
  end

  def trust_withdrawn_other_party?
    self.id == EventType.trust_withdrawn_other_party
  end
  
  def self.trust_cancel_initiator(return_only_id = true)
    return_only_id ? 47 : EventType.find(47)
  end

  def trust_cancel_initiator?
    self.id == EventType.trust_cancel_initiator
  end
  
  def self.trust_cancel_other_party(return_only_id = true)
    return_only_id ? 48 : EventType.find(48)
  end

  def trust_cancel_other_party?
    self.id == EventType.trust_cancel_other_party
  end
  
  def self.item_lost(return_only_id = true)
    return_only_id ? 49 : EventType.find(49)
  end

  def item_lost?
    self.id == EventType.item_lost
  end
  
  def self.item_found(return_only_id = true)
    return_only_id ? 50 : EventType.find(50)
  end

  def item_found?
    self.id == EventType.item_found
  end
  
  def self.item_damaged(return_only_id = true)
    return_only_id ? 51 : EventType.find(51)
  end

  def item_damaged?
    self.id == EventType.item_damaged
  end
  
  def self.item_repaired(return_only_id = true)
    return_only_id ? 52 : EventType.find(52)
  end

  def item_repaired?
    self.id == EventType.item_repaired
  end
  
  def self.item_removed(return_only_id = true)
    return_only_id ? 53 : EventType.find(53)
  end

  def item_removed?
    self.id == EventType.item_removed
  end
  
  def self.person_join(return_only_id = true)
    return_only_id ? 54 : EventType.find(54)
  end

  def person_join?
    self.id == EventType.person_join
  end
  
  def self.positive_feedback_gifter(return_only_id = true)
    return_only_id ? 55 : EventType.find(55)
  end

  def positive_feedback_gifter?
    self.id == EventType.positive_feedback_gifter
  end
  
  def self.positive_feedback_requester(return_only_id = true)
    return_only_id ? 56 : EventType.find(56)
  end

  def positive_feedback_requester?
    self.id == EventType.positive_feedback_requester
  end
  
  def self.negative_feedback_gifter(return_only_id = true)
    return_only_id ? 57 : EventType.find(57)
  end

  def negative_feedback_gifter?
    self.id == EventType.negative_feedback_gifter
  end
  
  def self.negative_feedback_requester(return_only_id = true)
    return_only_id ? 58 : EventType.find(58)
  end

  def negative_feedback_requester?
    self.id == EventType.negative_feedback_requester
  end
  
  def self.neutral_feedback_gifter(return_only_id = true)
    return_only_id ? 59 : EventType.find(59)
  end

  def neutral_feedback_gifter?
    self.id == EventType.neutral_feedback_gifter
  end
  
  def self.neutral_feedback_requester(return_only_id = true)
    return_only_id ? 60 : EventType.find(60)
  end

  def neutral_feedback_requester?
    self.id == EventType.neutral_feedback_requester
  end
=end
  
  
end
