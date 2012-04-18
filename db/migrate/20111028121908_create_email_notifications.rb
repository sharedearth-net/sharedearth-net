class CreateEmailNotifications < ActiveRecord::Migration
  def self.up
    create_table :email_notifications do |t|
      t.integer :person_id
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :email_notifications
  end
end
