module EntityModule
  def acts_as_entity(entity_type_id)
    include InstanceMethods

    # TODO : Add has_many relations for human network and respource network
    def has_human_network
      
    end

    def has_resource_network
      
    end

    has_one :entity, :foreign_key => :specific_entity_id, :conditions => ["entity_type_id = ?", entity_type_id], :autosave => true, :dependent => :destroy

  end
  
  module InstanceMethods
    
  end
end
