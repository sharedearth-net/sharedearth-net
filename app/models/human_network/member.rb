class Member < HumanNetwork

  scope :village_members, lambda { |village| where("entity_id = ? AND specific_entity_type = ?", village.id, "Village")}
  scope :person_villages, lambda { |person| where("person_id = ? AND specific_entity_type = ?", person.id, "Village")}  
end
