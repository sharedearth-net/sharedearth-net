module ItemsHelper
   def statuses
    Item::STATUSES.map{ |item| [item.pop, item.pop]}
  end
end
