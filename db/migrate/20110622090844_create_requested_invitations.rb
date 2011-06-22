class CreateRequestedInvitations < ActiveRecord::Migration
  def self.up
    create_table :requested_invitations do |t|
      t.integer :user_id
      t.date :invitation_sent_date

      t.timestamps
    end
  end

  def self.down
    drop_table :requested_invitations
  end
end
