When /^"([^"]*)" requests (.+)$/ do |person_name, model_name|
  item = model(model_name)  
  page.driver.post("/requests", { :params => { :item_id => item.id } })
end
