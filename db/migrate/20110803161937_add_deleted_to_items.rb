class AddDeletedToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :deleted, :boolean, :default => false
  end

  def self.down
    remove_column :items, :deleted
  end
end
