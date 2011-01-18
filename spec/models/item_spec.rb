require 'spec_helper'

describe Item do
  it { should belong_to(:owner) }
  
  it { should validate_presence_of(:item_type) }

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:description) }

  it { should validate_presence_of(:owner_id) }
  
  it { should validate_presence_of(:owner_type) }
end
