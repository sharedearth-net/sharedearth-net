require 'spec_helper'

describe Comment do
  
  describe "Scopes" do

    describe "#default scope" do
      before :each do
        @first_comment  = Factory.create(:comment, :created_at => Time.now)
        @second_comment = Factory.create(:comment, :created_at => (Time.now + 2.days))
      end
      
      it "should return a list of comments ordered by creation date" do
        comments = Comment.all
        comments.should == [@first_comment, @second_comment]
      end
    end
  end

  describe "#ordered_by_creation_desc" do
    before :each do
      @first_comment  = Factory.create(:comment, :created_at => Time.now)
      @second_comment = Factory.create(:comment, :created_at => (Time.now + 2.days))
    end
    
    it "should return a list of comments ordered by creation date in desc order" do
      comments = Comment.ordered_by_creation_desc
      comments.should == [@second_comment, @first_comment]
    end
  end
end
