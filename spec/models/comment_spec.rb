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
end

describe Comment, "validations" do
  let(:long_comment) { 'a' * 421 }

  it { should_not allow_value(long_comment).for(:comment) }
end
