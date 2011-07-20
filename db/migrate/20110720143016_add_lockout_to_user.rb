class AddLockoutToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :lockout, :datetime
  end

  def self.down
    remove_column :users, :lockout
  end
end
