Given /^"([^"]*)" accepts my trust request$/ do |person_name|
  PeopleNetworkRequest.last.confirm!
end

Then /^I should see "([^"]*)" only once$/ do |expression|
  page.has_css?('p', :text => expression, :count => 1).should be_true
end
