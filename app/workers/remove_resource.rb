require 'iron_worker'

class RemoveResource < IronWorker::Base
  merge "../models/entity_type.rb"
  merge "../models/resource_network.rb"
  attr_accessor :entity_id
  attr_accessor :items

  def run
    ResourceNetwork.village_resources(entity_id).items(items).each {|r| r.delete}
  end

end


