require 'spec_helper'

describe EventType do
  describe "self.weightage" do
    it "should return weightage of an event type" do
      EventType.weightage(18).should == 1
      EventType.weightage(19).should == 3
      EventType.weightage(20).should == 3
      EventType.weightage(21).should == 1
      EventType.weightage(85).should == 1
      EventType.weightage(86).should == 0
    end
  end
end
