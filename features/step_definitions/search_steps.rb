Given /^(.+) has not accepted the Privacy Policy$/ do |model_name|
  person = model(model_name)
  person.update_attributes(:accepted_pp => false)
end

Given /^(.+) is not authorized$/ do |model_name|
  person = model(model_name)
  person.update_attributes(:authorised_account => false)
end
