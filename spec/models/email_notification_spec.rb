require 'spec_helper'

describe EmailNotification do
  it { should have_db_column(:person_id).of_type(:integer) }
  it { should have_db_column(:email).of_type(:string) }
end
