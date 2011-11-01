class AddLastActivityToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :last_activity, :datetime
    users = User.all
    users.each do |u|
      u.update_attributes(:last_activity => Time.now)
    end
  end

  def self.down
    remove_column :users, :last_activity
  end
end
