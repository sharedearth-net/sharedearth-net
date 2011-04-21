class AddAvailableToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :available, :boolean
    Item.update_all :available => true
  end

  def self.down
    remove_column :items, :available
  end
end
