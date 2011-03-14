class RenamePersonNetworkRequestToPeopleNetworkRequest < ActiveRecord::Migration
  def self.up
    rename_table :person_network_requests, :people_network_requests
  end

  def self.down
    rename_table :people_network_requests, :person_network_requests
  end
end
