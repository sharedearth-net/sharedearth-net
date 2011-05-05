require File.dirname(__FILE__) + '/../spec_helper'

describe Feedback do
  it "should be valid" do
    Feedback.new.should be_valid
  end
end
