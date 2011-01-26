require 'spec_helper'

describe Person do
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:user_id) }

  it { should have_many(:items) }
  
  it { should validate_presence_of(:name) }
end
