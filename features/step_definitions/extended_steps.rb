#I should see "Bike" 3 times
Then /^(?:|I )should see \/([^\/]*)\/ (\d+)(?:x|X| times?)?$/ do |regexp, count|
  regexp = Regexp.new(regexp)
  count = count.to_i
  page.find(:xpath, '//body').text.split(regexp).length.should == count+1
end

