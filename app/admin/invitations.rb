ActiveAdmin.register Invitation do
  scope :all, :default => true

  index do
     column "Inviter", :inviter, :sortable => false
     column "Unique key", :invitation_unique_key
     column "Invitation active", :invitation_active
     column "Invitee", :invitee, :sortable => false
     column "Accepted date", :accepted_date
  end
  
  form :partial => "form"

  
end
