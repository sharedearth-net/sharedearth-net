class AddEntities < ActiveRecord::Migration
  def self.up
  #Add entity information for current enities like person, item etc.
    people = Person.all
    items  = Item.all
    people.each do |person|
      Entity.create!(:entity_type_id => 1, :specific_entity_id => person.id)
    end
    items.each do |item|
      Entity.create!(:entity_type_id => 2, :specific_entity_id => item.id)
    end
  end

  def self.down
  end
end
