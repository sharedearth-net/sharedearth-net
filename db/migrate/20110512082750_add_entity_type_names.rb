class AddEntityTypeNames < ActiveRecord::Migration
  def self.up
  #insert entity type names to entity types table
    entity_types = [
                      {:id => 1, :name => 'Person'},
                      {:id => 2, :name => 'Item'},
                      {:id => 3, :name => 'Skill'},
                      {:id => 4, :name => 'Village'},
                      {:id => 5, :name => 'Community'},
                      {:id => 6, :name => 'Project'},
                      {:id => 7, :name => 'Trusted Person'}
                      ]
     entity_types.each do |entity|
       et = EntityType.new(:entity_type_name => entity[:name])
       et.id = entity[:id]
       et.save!
     end
  end

  def self.down
  end
end
