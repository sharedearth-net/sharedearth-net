class AddStatusToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :status, :integer
    
    Item.update_all :status => Item::STATUS_NORMAL
  end

  def self.down
    remove_column :items, :status
  end
end
