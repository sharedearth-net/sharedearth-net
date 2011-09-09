class AddInvitationCountToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :invitations_count, :integer
  end

  def self.down
    remove_column :people, :invitations_count
  end
end
