module ItemsHelper
   def statuses
    Item::STATUSES.map{ |item| [item.pop, item.pop]}
  end
  
  def purposes
    Item::PURPOSES.map{ |item| [item.pop, item.pop]}
  end
  
  def generic_name(item)
    item.name.present? ? item.name : item.item_type
  end
   
  def owner_only(item, &block)
    capture(&block) if current_user && item.is_owner?(current_user.person)
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

  def truncate_item_type(generic_name_string)
    if generic_name_string.length > 23
      generic_name_string[0..20] + ".."
    else
      generic_name_string
    end
  end
  
 def truncate_item_name(generic_name_string)
    if generic_name_string.length > 48
      generic_name_string[0..45] + ".."
    else
      generic_name_string
    end
  end
end
