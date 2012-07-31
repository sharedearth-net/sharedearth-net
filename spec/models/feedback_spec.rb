require 'spec_helper'

describe Feedback, "validations" do
  let(:long_feedback_note) { 'd' * 401 } 

  let(:some_feedback)  { FactoryGirl.create(:feedback) }

  it "should not be valid if the feedback note is too long" do
    some_feedback.stub(:neutral_or_negative?).and_return(true)
    some_feedback.feedback_note = long_feedback_note
    some_feedback.should_not be_valid
  end
end
