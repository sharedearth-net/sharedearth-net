class EntityType < ActiveRecord::Base
  PERSON_ENTITY         = 1.freeze
  ITEM_ENTITY           = 2.freeze
  SKILL_ENTITY          = 3.freeze
  VILLAGE_ENTITY        = 4.freeze
  COMMUNITY_ENTITY      = 5.freeze
  PROJECT_ENTITY        = 6.freeze
  TRUSTED_PERSON_ENTITY = 7.freeze
end
