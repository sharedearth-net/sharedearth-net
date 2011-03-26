class AddPurposeToItems < ActiveRecord::Migration
def self.up
    add_column :items, :purpose, :integer
    
    Item.update_all :purpose => Item::PURPOSE_SHARE
  end

  def self.down
    remove_column :items, :purpose
  end
end
