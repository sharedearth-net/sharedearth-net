class GroupAdmin < HumanNetwork

  scope :village_admins, lambda { |village| where("entity_id = ? AND entity_type = ?", village.id, "Village")}
end
