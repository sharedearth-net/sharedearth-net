class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :inviter_person_id
      t.integer :invitation_unique_key
      t.boolean :invitation_active
      t.date :accepted_date
      t.integer :invitee_person_id
      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
