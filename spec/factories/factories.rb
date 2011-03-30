Factory.define :user do |u|
  u.provider "Facebook"
  u.uid      "1221401522"
  u.nickname "demo"
end

Factory.define :person do |p|
  p.name "Test Member"
end

Factory.define :item do |i|
  i.item_type "Bike"
  i.name "Mountainbike"
  i.description "Big beautifyl bike"
  i.owner_id 1
  i.owner_type "Person"
  i.status Item::STATUS_NORMAL
  i.purpose Item::PURPOSE_SHARE
end

Factory.define :item_request do |i|
  i.requester_type "Person"
  #requester_id
  i.gifter_type "Person"
  #gifter_id
  i.description "Would you like to borrow me something?"
  i.status ItemRequest::STATUS_REQUESTED
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
  i.secondary_short_name "Maria"
  i.secondary_full_name "Maria Bell"
  i.related_id 1
  i.related_type "ItemRequest"
  i.event_type_id 1
end
