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
		itype = item.item_type.downcase
		item_types[itype] = item_types[itype] || item.gift?
		end
		item_types
	end
end
