require 'spec_helper'

describe PeopleNetworkRequest do
  it { should belong_to(:person) }
  it { should belong_to(:trusted_person) }
  it { should validate_presence_of(:person_id) }
  it { should validate_presence_of(:trusted_person_id) }
end
