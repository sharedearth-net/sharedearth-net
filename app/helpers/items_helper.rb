module ItemsHelper
   def statuses
    Item::STATUSES.map{ |item| [item.pop, item.pop]}
  end
  
  def purposes
    Item::PURPOSES.map{ |item| [item.pop, item.pop]}
  end
  
  def item_types_with_gift_status(items)
		item_types = {}
		items.each do |item|
		 item_types[item.item_type] = item_types[item.item_type] || item.gift?
		end
		item_types
		end
end
