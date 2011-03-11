class PersonNetworkRequest < ActiveRecord::Base
  belongs_to :person
  belongs_to :trusted_person
end
