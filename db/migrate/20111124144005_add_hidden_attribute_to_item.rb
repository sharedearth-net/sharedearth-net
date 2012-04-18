class AddHiddenAttributeToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :items, :hidden
  end
end
