Factory.define :user do |u|
  u.provider "Facebook"
  u.sequence(:uid) { |n|  Time.now.to_i.to_s + "#{n}" }
  u.token '111'
end

Factory.define :person do |p|
  p.name "John"
  p.association :user, :factory => :user
  p.association :reputation_rating, :factory => :reputation_rating
  p.authorised_account true
  p.accepted_tc true
  p.accepted_pp true
  p.accepted_tr true 
end

Factory.define :new_person, :class => Person do |p|
  p.name "John"
  p.association :user, :factory => :user
  p.association :reputation_rating, :factory => :reputation_rating
  p.authorised_account false
  p.accepted_tc false
  p.accepted_pp false
end

Factory.define :reputation_rating do |r|
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

Factory.define :item do |i|
  i.item_type "Bike"
  i.name "Mountainbike"
  i.description "Big beautiful bike"
  i.association :owner, :factory => :person
  i.status Item::STATUS_NORMAL
  i.purpose Item::PURPOSE_SHARE
end

Factory.define :item_request do |i|
  i.association :item, :factory => :item
  i.requester_type "Person"
  i.association :requester, :factory => :person
  i.association :gifter, :factory => :person
  i.gifter_type "Person"
  i.description "Would you like to borrow me something?"
  i.status ItemRequest::STATUS_REQUESTED
end

Factory.define :feedback do |f|
  f.association :item_request, :factory => :item_request
  f.association :person, :factory => :person
  f.feedback Feedback::FEEDBACK_POSITIVE
end

Factory.define :people_network do |p|
  p.entity_type_id 7
end

Factory.define :people_network_request do |p|
end

Factory.define :event_log do |i|
  i.association :primary, :factory => :person
  i.primary_short_name 'Shary'
  i.primary_full_name 'Shary Demo'  
end

Factory.define :event_display do |e|
end

Factory.define :activity_log do |i|
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

Factory.define :invitation do |i|
  i.inviter_person_id '1'
  i.invitation_active true
end

Factory.define :comment do |comment|
end

Factory.define :resource_network do |res_network|
end
