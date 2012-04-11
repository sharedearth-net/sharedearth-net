module ItemsHelper
   def statuses
    Item::STATUSES.map{ |item| [item.pop, item.pop]}
  end
  
  def purposes
    Item::PURPOSES.map{ |item| [item.pop, item.pop]}
  end
  
  def generic_name item
    item.name? ? item.name : item.item_type
  end
  
  def item_types_with_gift_status(items)
		item_types = {}
		items.each do |item|
			itype = item.item_type.downcase
			item_types[itype] = item_types[itype] || item.gift?
		end
		item_types_array = []
		item_types.each do |type, is_gift|
			item_types_array << { :type => type, :is_gift => is_gift }
		end
		item_types_array.sort_by { |item_type| item_type[:type] }
	end

  def truncate(genericNameString)
	  if genericNameString.length > 23
		  genericNameString[0..20] + ".."
	  else
		  genericNameString
	  end
  end
end
