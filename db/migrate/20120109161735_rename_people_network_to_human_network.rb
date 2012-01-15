class RenamePeopleNetworkToHumanNetwork < ActiveRecord::Migration
  def self.up
    rename_table :people_networks, :human_networks
    
    
    
  end

  def self.down
    rename_table :human_networks, :people_networks
  end
end
