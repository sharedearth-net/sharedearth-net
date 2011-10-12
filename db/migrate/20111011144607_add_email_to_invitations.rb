class AddEmailToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :invitee_email, :string
  end

  def self.down
    remove_column :invitations, :invitee_email
  end
end
