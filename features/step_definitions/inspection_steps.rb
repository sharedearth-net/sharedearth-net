def prepare_words(words, multiple)

  words = words.scan(/('([^']*)'|"([^"]*)")/).to_a.map{ |w| w[1] || w[2] }
  words = words.map(&:strip)

  # Enable correct quoting...
  words = words.map do |word|
    if word.starts_with?("'")
      if word.ends_with?("'")
        word = word[(1..word.length-2)]
      else
        flunk("Syntax error: #{word} started with a quote but did not end with one...")
      end
    elsif word.starts_with?('"')
      if word.ends_with?('"')
        word = word[(1..word.length-2)]
      else
        flunk("Syntax error: #{word} started with a double quote but did not end with one...")
      end
    else
      word
    end
  end

  if multiple == "long date" || multiple == "long dates"
    words = words.map{ |d| Chronic.parse(d).to_date.to_s(:long) }
  elsif multiple == "short date" || multiple == "short dates"
    words = words.map{ |d| Chronic.parse(d).to_date.to_s(:euro_date_part) }
  end
  
  return words
end

Then /^I (should|should not) see the (word|words|long date|long dates|short date|short dates|regex|regexes) (.*)$/ do |should_or_should_not,multiple,words|
  words = prepare_words(words, multiple)
  error_words = []
  words.each do |word|
    begin
      steps %Q{
      Then I should see "#{word}"
      }
    rescue Exception => e
      error_words << word
    end
  end

  if should_or_should_not == "should"

    if !error_words.empty?
      flunk("Cannot find the #{multiple}: #{error_words.map{ |w| "'#{w}'" }.to_sentence} anywhere on this page")
    end

  elsif should_or_should_not == "should not"

    if error_words.length != words.length
      words_on_page = words - error_words
      flunk "I found the #{words_on_page.length > 1 ? "words" : "word"}: #{words_on_page.map{ |w| "'#{w}'" }.to_sentence} somewhere on this page"
    end

  end

end

Then /^I fill in active invitation$/ do
  invitation = Invitation.find_by_invitation_active(true)
  Then %{I fill in "key" with "#{invitation.invitation_unique_key}"}
end
