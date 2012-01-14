class RenamePeopleNetworkRequestToNetworkRequest < ActiveRecord::Migration
  def self.up
    rename_table :people_network_requests, :network_requests
  end

  def self.down
    rename_table :network_requests, :people_network_requests
  end
end
