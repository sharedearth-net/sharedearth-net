require 'iron_worker'

class AddResource < IronWorker::Base
  merge "../models/entity_type.rb"
  merge "../models/resource_network.rb"
  attr_accessor :entity_id
  attr_accessor :entity_type_id
  attr_accessor :items

  def run
    items.each { |item| ResourceNetwork.create!(:entity_id => entity_id, :entity_type_id => entity_type_id, :resource_id => item['id'], :resource_type_id => EntityType::ITEM_ENTITY) }
  end

end
