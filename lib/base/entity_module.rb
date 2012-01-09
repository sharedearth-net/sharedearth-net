module EntityModule
  def acts_as_entity(entity_type_id)
    include InstanceMethods

    # TODO : Add has_many relations for human network and respource network
    def has_human_network
      
    end

    def has_resource_network
      
    end

    has_one :entity, :as => :specific_entity, :autosave => true, :dependent => :destroy
    alias_method_chain :entity, :build

    entity_attributes = Entity.content_columns.map(&:name) #<-- gives access to all columns of Entity
    # define the attribute accessor method
    def ent_attr_accessor(*attribute_array)
      attribute_array.each do |att|
        define_method(att) do
          entity.send(att)
        end
        define_method("#{att}=") do |val|
          entity.send("#{att}=",val)
        end
      end
    end

    ent_attr_accessor *entity_attributes #<- delegating the attributes

  end

  module InstanceMethods
    def entity_with_build
      entity_without_build || build_entity
    end
  end
end
