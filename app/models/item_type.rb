class ItemType < ActiveRecord::Base
  
  def increase_item_count
    self.item_count += 1
    self.save!
    self
  end
  
  def reduce_item_count
    self.item_count -= 1
    self.save!
    self
  end
  
  def self.create_from_item item
    item_type = ItemType.new
    item_type.item_count = 1
    item_type.item_type = item.item_type
    item_type.save!
    item_type
  end
end