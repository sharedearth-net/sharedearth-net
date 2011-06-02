When /I edit "(.*)"/ do |model|
  selector = "li[contains('#{model}')]"
  within(selector) do
    click_link("edit")
  end
end

When /I show "(.*)"/ do |model|
  selector = "li[contains('#{model}')]"
  within(selector) do
    click_link("show")
  end
end

#Fix destroy
When /I destroy "(.*)"/ do |model|
  selector = "li[contains('#{model}')]"
  within(selector) do
    click_link("destroy")
  end
end

When /I request "(.*)"/ do |model|
  steps %Q{
    And I follow "#{model}"
  }
end


When /^I click the "(.+)" link within the row containing "(.+)"$/ do |
link, text|
  selector = "table/tr[contains('#{text}')]"
  click_link_within  selector, link
end

Then /^(?:|I )should see name "([^"]*)" on the row containing "([^"]*)"$/ do |name, text|
  selector = "table/tr[contains('#{text}')]"
  within(selector) do
      Then %{I should see "#{name}"}
  end
end

#Then I should see clients table
#  | Zeus   | in care  |
#  | Atina  | out of care  |

Then(/^I should see ([^"]*) table$/) do |table_id, expected_table|
   html_table = tableish("table##{table_id}", "tr, td" ).to_a
   html_table.map! { |r| r.map! { |c| c.gsub(/<.+?>/, '') } }
   expected_table.diff!(html_table)
end


#For debugging check on what page I am
Then /^show me the page to your scenario$/ do
  current_path = URI.parse(current_url).select(:path, :query).compact.join('?')
end
