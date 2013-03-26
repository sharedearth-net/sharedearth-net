class Village < ActiveRecord::Base
  acts_as_entity
  attr_accessible :name, :description, :street, :postcode, :state, :country,:city,:uid
  validates_length_of    :name, :maximum => 50
  validates_length_of    :state, :maximum => 30
  validates_length_of    :description, :maximum => 400
  validates_presence_of  :name
  validates_presence_of  :country
  validates_presence_of  :state

  has_human_network :human_networks

  before_create :generate_key
  after_create :create_entity_for_village

  def generate_key(length=6)
    random_number = Random.rand(999999)
    self.uid = random_number
    # Ensure uniqueness of the token..
    generate_key unless Village.find_by_uid(random_number).nil?
  end

  def is_member?(entity)
    Member.village_members(self).member(entity).first
  end

  def is_admin?(entity)
    GroupAdmin.village_admins(self).member(entity).first
  end

  def is_member_or_admin?(entity)
    GroupAdmin.village_admins(self).member(entity).first || Member.village_members(self).member(entity).first
  end

  def join!(entity)
    self.add_items!(entity)
    Member.create!(:person_id => entity.id, :specific_entity => self, :entity_id => self.id)
  end

  def add_admin!(entity)
    GroupAdmin.create!(:person_id => entity.id, :specific_entity => self)
  end

  def add_items!(entity)
    worker = AddResource.new
    worker.entity_id = self.id
    worker.entity_type_id = EntityType::VILLAGE_ENTITY
    worker.items = entity.items
    ENV['ENABLE_IRON_WORKER'].nil? ? worker.run_local : worker.queue
  end

  def add_item!(item)
    ResourceNetwork.create!(:entity_id => self.id, :entity_type_id => EntityType::VILLAGE_ENTITY, :resource_id => item.id, :resource_type_id => EntityType::ITEM_ENTITY)
  end

  def remove_item!(item)
    resource = ResourceNetwork.item(item)
    resource.destroy unless resource.nil?
  end

  def leave!(entity)
    HumanNetwork.village_members(self).member(entity).each{ |n| n.delete }
    self.remove_items!(entity)
  end

  def remove_items!(entity)
    worker = RemoveResource.new
    worker.entity_id = self.id
    worker.items = entity.items
    ENV['ENABLE_IRON_WORKER'].nil? ? worker.run_local : worker.queue
  end

  def self.belongs_to_person(person)
    HumanNetwork.part_of_village(person).map(&:entity_id) - [nil]
  end
  
  def self.person_villages(person)    
    Village.where("id IN (#{belongs_to_person(person).join(',')})")
  end

  #handle_asynchronously :add_items!
  #handle_asynchronously :remove_items!

  private

  def create_entity_for_village
    Entity.create!(:specific_entity_type => "Village", :specific_entity_id => self.id)
  end
end
