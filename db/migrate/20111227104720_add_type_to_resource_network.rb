class AddTypeToResourceNetwork < ActiveRecord::Migration
  def self.up
    add_column :resource_networks, :type, :integer, :default => ResourceNetwork::TYPE_GIFTER_AND_POSSESSOR
  end

  def self.down
    remove_column :resource_networks, :type
  end
end
