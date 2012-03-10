class Village < ActiveRecord::Base
  acts_as_entity
  attr_accessible :name, :description, :street, :postcode, :state, :country, :uid
  validates_length_of    :name, :maximum => 50
  validates_length_of    :state, :maximum => 30
  validates_length_of    :description, :maximum => 400
  validates_presence_of  :name
  validates_presence_of  :country
  validates_presence_of  :state

  before_create :generate_key
  after_create :create_entity_for_village

  def generate_key(length=6)
    random_number = Random.rand(1-999999)
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
    entity.items.each { |item| ResourceNetwork.create!(:entity_id => self.id, :entity_type_id => EntityType::VILLAGE_ENTITY, :resource_id => item.id, :resource_type_id => EntityType::ITEM_ENTITY) }
    Member.create!(:human => entity, :entity => self)
  end

  def add_admin!(entity)
    GroupAdmin.create!(:human => entity, :entity => self)
  end

  def add_items!(entity)
    entity.items.each { |item| ResourceNetwork.create!(:entity_id => self.id, :entity_type_id => EntityType::VILLAGE_ENTITY, :resource_id => item.id, :resource_type_id => EntityType::ITEM_ENTITY) }
  end

  def add_item!(item)
    ResourceNetwork.create!(:entity_id => self.id, :entity_type_id => EntityType::VILLAGE_ENTITY, :resource_id => item.id, :resource_type_id => EntityType::ITEM_ENTITY)
  end

  def remove_item!(item)
    resource = ResourceNetwork.item(item)
    resource.destroy unless resource.nil?
  end

  def leave!(entity)
    ResourceNetwork.village_resources(self).items(entity.items).each {|r| r.delete}
    HumanNetwork.village_members(self).member(entity).each{ |n| n.delete }
  end

  private

  def create_entity_for_village
    Entity.create!(:specific_entity_type => "Village", :specific_entity_id => self.id)
  end
end
