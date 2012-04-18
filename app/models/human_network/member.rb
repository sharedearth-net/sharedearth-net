class Member < HumanNetwork

  scope :village_members, lambda { |village| where("entity_id = ? AND entity_type = ?", village.id, "Village")}
  scope :person_villages, lambda { |person| where("person_id = ? AND entity_type = ?", person.id, "Village")}
end
