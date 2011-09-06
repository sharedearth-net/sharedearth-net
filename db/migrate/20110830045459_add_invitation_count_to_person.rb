class AddInvitationCountToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :invitations_count, :integer, :default => '20'
  end

  def self.down
    remove_column :people, :invitations_count
  end
end
