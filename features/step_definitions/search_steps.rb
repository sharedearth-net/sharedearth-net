Given /^(.+) has not accepted the Privacy Policy$/ do |model_name|
  person = model(model_name)
  person.update_attributes(:accepted_pp => false)
end

Given /^"(.+)" is not authorised$/ do |model_name|
  @person = Person.find_by_name(model_name)
  @person.update_attributes(:authorised_account => false)
end
