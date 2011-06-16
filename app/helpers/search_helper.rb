module SearchHelper
 def items_search
   params[:type] == 'items'
 end
 
 def people_search
   params[:type] == 'people'
 end
 
 def all_search
   params[:type] == 'all'
 end
 
 def smart_search
   params[:type] == ''
 end
end
