class EntityType
  PERSON_ENTITY         = 1.freeze
  ITEM_ENTITY           = 2.freeze
  SKILL_ENTITY          = 3.freeze
  VILLAGE_ENTITY        = 4.freeze
  COMMUNITY_ENTITY      = 5.freeze
  PROJECT_ENTITY        = 6.freeze
  TRUSTED_PERSON_ENTITY = 7.freeze
  MUTUAL_PERSON_ENTITY = 	8.freeze

  ENTITY_TYPES = {
		PERSON_ENTITY         => 'Person',
		ITEM_ENTITY           => 'Item',
		SKILL_ENTITY          => 'Skill',
		VILLAGE_ENTITY        => 'Village',
		COMMUNITY_ENTITY      => 'Community',
		PROJECT_ENTITY        => 'Project',
		TRUSTED_PERSON_ENTITY => 'TrustedPerson',
		MUTUAL_PERSON_ENTITY  => 'MutualPerson'
  }
end
