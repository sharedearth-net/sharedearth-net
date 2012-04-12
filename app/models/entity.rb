class Entity < ActiveRecord::Base

  belongs_to :specific_entity, :polymorphic => true

  scope :item, lambda { |entity| where("specific_entity_type =? AND specific_entity_id = ?", "Item", entity.id) }
  scope :villages_with_ids, lambda { |village_ids| where("specific_entity_id IN (?) AND specific_entity_type = ?", village_ids, "Village")}

  GROUP_ENTITIES = ["Village"]

  #Find entities that are connected with person involved, update with more generic, pairing up id and entity type
  def self.groups_with_person(person)
    entities = []
    village_ids = HumanNetwork.entity_types(GROUP_ENTITIES).member(person).map(&:entity_id)
    entities += self.villages_with_ids(village_ids)
  end

  def network_activity
    my_people_id = self.specific_entity.human_networks.specific_entity_network(self.specific_entity).collect { |n| n.person_id }
    my_people_id << id

    EventDisplay.select('DISTINCT event_log_id').
                 where(:person_id => my_people_id).
                 order('event_log_id DESC').
                 includes(:event_log)
  end

  def get_items
    ResourceNetwork.items_belong_to(self.specific_entity)
  end
end
