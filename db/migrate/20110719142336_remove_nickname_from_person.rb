class RemoveNicknameFromPerson < ActiveRecord::Migration
  def self.up
    remove_column :users, :nickname
  end

  def self.down
  end
end
