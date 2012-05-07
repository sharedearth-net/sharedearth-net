class CreateItemTypes < ActiveRecord::Migration
  def self.up
    create_table :item_types, :force => true do |table|
      table.string  :item_type
      table.integer  :parent_id
      table.integer  :item_count, :default => 0      
      table.integer  :ask_count, :default => 0
      table.boolean  :priority_flag, :default => false
    end
    
    add_column :items, :item_type_id, :integer
    
    # copy all item types from items table to item types table
    Item.all.each do |item|
      puts "Running for item #{item.id}"
      existing_item_type = ItemType.find_by_item_type(item.item_type)
      if existing_item_type.present?
        existing_item_type.item_count += 1
        existing_item_type.save!
        
        item.item_type_id = existing_item_type.id
        item.save!
      else
        item_type = ItemType.new
        item_type.item_count = 1
        item_type.item_type = item.item_type
        item_type.save!
        
        item.item_type_id = item_type.reload.id
        item.save!
      end
    end
  end

  def self.down
    remove_column :items, :item_type_id
    drop_table :item_types
  end
end
