require 'spec_helper'

describe ActivityLog do
   it { should have_db_column(:email_notification_id).of_type(:integer) }
   it { should have_db_column(:read).of_type(:boolean) }
end
