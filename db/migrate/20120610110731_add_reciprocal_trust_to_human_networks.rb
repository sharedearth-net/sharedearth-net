class AddReciprocalTrustToHumanNetworks < ActiveRecord::Migration
  def self.up
    add_column :human_networks, :reciprocal_trust, :boolean
    network = HumanNetwork.where(:network_type => "TrustedNetwork")
    network.each do |n|
      other = TrustedNetwork.where(:entity_id => n.person_id).first
      if other && n.entity_id == other.person_id
        n.update_attributes(:reciprocal_trust=> true)
      end
    end
  end

  def self.down
    remove_column :human_networks, :reciprocal_trust, :boolean
  end
end
