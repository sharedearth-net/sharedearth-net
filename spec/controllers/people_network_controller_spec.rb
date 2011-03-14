require 'spec_helper'

describe PeopleNetworkController do
  it_should_require_signed_in_user_for_actions :all
end
