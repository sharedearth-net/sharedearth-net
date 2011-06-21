require File.dirname(__FILE__) + '/../spec_helper'

describe Invitation do
  it "should be valid" do
    Invitation.new.should be_valid
  end
end
