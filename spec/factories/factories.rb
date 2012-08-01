FactoryGirl.define do
  factory :user do |u|
    u.provider "facebook"
    u.sequence(:uid) { |n|  Time.now.to_i.to_s + "#{n}" }
    u.token '111'
    u.last_activity Time.now
  end

  factory :user_with_person, :class => User do |u|
    u.provider "facebook"
    u.sequence(:uid) { |n|  Time.now.to_i.to_s + "1#{n}" }
    u.token '111'
    u.last_activity Time.now
    u.association :person, :factory => :person
  end

  factory :person do |p|
    p.name "John"
    p.email "john@doe.com"
    p.location "Australia"
    p.authorised_account true
    p.accepted_tc true
    p.accepted_pp true
    p.accepted_tr true
    p.email_notification_count 0
    after(:create) do |person|
      FactoryGirl.create(:user, :person => person)
    end
  end

  factory :new_person, :class => Person do |p|
    p.name "John"
    p.association :users, :factory => :user
    p.association :reputation_rating, :factory => :reputation_rating
    p.authorised_account false
    p.accepted_tc false
    p.accepted_pp false
  end

  factory :reputation_rating do |r|
    r.person_id 1
    r.gift_actions 0
    r.distinct_people 0
    r.total_actions 0
    r.positive_feedback 0
    r.negative_feedback 0
    r.neutral_feedback  0
    r.requests_received 0
    r.requests_answered 0
    r.trusted_network_count 0
    r.activity_level 0
  end

  factory :item do |i|
    i.item_type "Bike"
    i.name "Mountainbike"
    i.description "Big beautiful bike"
    i.association :owner, :factory => :person
    i.status Item::STATUS_NORMAL
    i.purpose Item::PURPOSE_SHARE
    i.available true
    i.photo_file_name "test.jpg"
    i.photo_content_type "image/jpeg"
    i.photo_file_size 100000
    i.photo_updated_at Time.now
  end

  factory :item_request do |i|
    i.association :item, :factory => :item
    i.requester_type "Person"
    i.association :requester, :factory => :person
    i.association :gifter, :factory => :person
    i.gifter_type "Person"
    i.description "Would you like to borrow me something?"
    i.status ItemRequest::STATUS_REQUESTED
  end

  factory :feedback do |f|
    f.association :item_request, :factory => :item_request
    f.association :person, :factory => :person
    f.feedback Feedback::FEEDBACK_POSITIVE
  end

  factory :human_network do |p|
    p.network_type "TrustedNetwork"
    p.association :entity, :factory => :person
    p.association :person, :factory => :person
  end

  factory :new_village_network, :class => HumanNetwork do |p|
    p.network_type "Member"
    p.entity_type "Village"
  end

  factory :village_network, :class => HumanNetwork do |p|
    p.network_type "Member"
    p.entity_type "Village"
    p.association :entity, :factory => :village
    p.association :person, :factory => :person
  end

  factory :facebook_friend_network, :class => HumanNetwork do |p|
    p.network_type "FacebookFriend"
    p.association :entity, :factory => :person
    p.association :person, :factory => :person
  end

  factory :network_request do |p|
  end

  factory :event_log do |i|
    i.association :primary, :factory => :person
    i.primary_short_name 'Shary'
    i.primary_full_name 'Shary Demo'
  end

  factory :event_display do |e|
  end

  factory :event_entity do |e|
    e.entity_type "Person"
    e.entity_id 1234455
    e.association :event_log, :factory => :event_log
    e.user_only false
  end

  factory :activity_log do |i|
    i.event_code 1
    i.primary_id 1
    i.primary_type "Person"
    i.action_object_id 1
    i.action_object_type "Item"
    i.action_object_type_readable "Bike"
    i.secondary_type "Person"
    i.secondary_id 1
    i.secondary_short_name "Sharen"
    i.secondary_full_name "Sharen Bell"
    i.related_id 1
    i.related_type "ItemRequest"
    i.event_type_id 1
  end

  factory :invitation do |i|
    i.inviter_person_id '1'
    i.invitation_active true
  end

  factory :comment do |i|
    i.comment "My awesome comment"
  end

  factory :resource_network do |i|
    i.entity_type_id 1
    i.resource_type_id 2
  end

  factory :village do |i|
    i.name 'Sidney'
    i.description 'Opera house'
    i.street 'By the sea'
    i.country 'Australia'
    i.state 'Australia'
    i.sequence(:uid) { |n|  Time.now.to_i.to_s + "#{n}" }
    i.postcode 200
  end

  factory :facebook_friends_job do |f|
    f.association :user, :factory => :user
    f.status :success
  end

  factory :item_type do |i|
    i.item_type "bike"
    i.item_count 1
    i.ask_count 0
    i.priority_flag false
  end
end