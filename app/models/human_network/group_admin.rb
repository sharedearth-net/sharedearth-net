class GroupAdmin < HumanNetwork

  scope :village_admins, lambda { |village| where("specific_entity_id = ? AND specific_entity_type = ?", village.id, "Village")}
  scope :gift_creator, lambda { |gift| where("specific_entity_id = ? AND specific_entity_type = ?", gift.id, "Gift")}
end
