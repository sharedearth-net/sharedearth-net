class EventEntity < ActiveRecord::Base
  belongs_to :event_log
  belongs_to :entity, :polymorphic => true # person, community, ... anyone and anything related to the event
  
  scope :involves, lambda { |entity| where("(entity_id = ? AND entity_type = ?)", entity.id, entity.class.to_s) }
  scope :human_networks, joins("human_networks on event_entities.entity_id = human_networks.entity_id and event_entities.entity_type = human_networks.entity_type")
  scope :event_logs, joins("event_logs on event_entities.event_log_id = event_logs.id")
  
  def self.recent_events_for person
    event_entities = Arel::Table.new(EventEntity.table_name.to_sym)
    event_logs = Arel::Table.new(EventLog.table_name.to_sym)
    human_networks =  Arel::Table.new(HumanNetwork.table_name.to_sym)
    
    query = event_entities.join(event_logs).on(event_entities[:event_log_id].eq(event_logs[:id]))
    .join(human_networks).on(event_entities[:entity_id].eq(human_networks[:entity_id]))
    .where(human_networks[:person_id].eq(person.id))
    .where(event_entities[:user_only].eq(false))
    .project(event_entities[:event_log_id], event_logs[:event_type_id], human_networks[:network_type])
    .order("#{event_entities.name}.created_at desc")
    .take(25)
    
    EventEntity.find_by_sql(query.to_sql)
  end
  
  def self.create_for_related_groups person, event_log
    Member.person_villages(person).each do |village| 
      EventEntity.create!(:event_log => event_log, :entity => village.entity)
    end
  end
end
