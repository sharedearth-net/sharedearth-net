class AddExistingResourceNetwork < ActiveRecord::Migration
  def self.up
    people = Person.all
    people.each do |person|
      person.items.each do |item|
        ResourceNetwork.create!(:entity_id => person.id, :entity_type_id => 1, :resource_id => item.id, :resource_type_id => 2)
      end 
    end
  end

  def self.down
  end
end
