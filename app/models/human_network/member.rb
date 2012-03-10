class Member < HumanNetwork

  scope :village_members, lambda { |village| where("entity_id = ? AND entity_type = ?", village.id, "Village")}
end
