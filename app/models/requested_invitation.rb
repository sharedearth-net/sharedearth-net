class RequestedInvitation < ActiveRecord::Base
  has_one :user
  #validate :user_is_unique

  def user_is_unique
    # Get the current count of objects having this link
    count = RequestedInvitation.count(:conditions => ['user_id = ?', self.user_id])

    # Add an error to the model if the count is not zero
    errors.add_to_base("You already requested invitation") unless count == 0
  end
  def sent!
     self.sent = true
		 save!
  end
  
  def accepted!
  	 self.accepted = true
     save!
  end
end
