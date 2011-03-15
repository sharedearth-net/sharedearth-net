class CreatePeopleNetworks < ActiveRecord::Migration
  def self.up
    create_table :people_networks do |t|
      t.references :person
      t.references :trusted_person
      t.timestamps
    end
  end

  def self.down
    drop_table :people_networks
  end
end
