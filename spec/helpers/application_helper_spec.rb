require 'spec_helper'

describe ApplicationHelper do 
  describe "indefiniteArticles function" do 
    it "should return '' if a word ends with 's'" do 
      s_word = indefiniteArticles("oranges")
      s_word.should == ""
	end
	
    it "should return 'an' if a word starts with a vowel" do 
      vowel_word = indefiniteArticles("apple")
      vowel_word.should == "an"
	end
	
    it "should return 'a' if a word starts with a consonant and does not end in an s" do 
      word = indefiniteArticles("book")
      word.should == "a"
	end
  end
end