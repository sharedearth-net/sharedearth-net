class CreatePersonNetworkRequests < ActiveRecord::Migration
  def self.up
    create_table :person_network_requests do |t|
      t.references :person
      t.references :trusted_person

      t.timestamps
    end
  end

  def self.down
    drop_table :person_network_requests
  end
end
