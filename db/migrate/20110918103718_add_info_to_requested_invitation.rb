class AddInfoToRequestedInvitation < ActiveRecord::Migration
  def self.up
    add_column :requested_invitations, :sent, :boolean
    add_column :requested_invitations, :accepted, :boolean
  end

  def self.down
    remove_column :requested_invitations, :sent
    remove_column :requested_invitations, :accepted
  end
end
