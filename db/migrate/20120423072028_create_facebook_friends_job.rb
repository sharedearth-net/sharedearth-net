class CreateFacebookFriendsJob < ActiveRecord::Migration
  def self.up
    create_table :facebook_friends_jobs do |t|
      t.references :user
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_friends_jobs
  end
end
