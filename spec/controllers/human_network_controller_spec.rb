require 'spec_helper'

describe HumanNetworkController do
  it_should_require_signed_in_user_for_actions :all
end
