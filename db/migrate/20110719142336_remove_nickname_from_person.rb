class RemoveNicknameFromPerson < ActiveRecord::Migration
  def self.up
    remove_column :people, :nickname
  end

  def self.down
  end
end
