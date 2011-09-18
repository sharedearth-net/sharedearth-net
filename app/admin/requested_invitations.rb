ActiveAdmin.register RequestedInvitation do
  # filter :user_id
   scope :sent_invitations do |tasks|
     tasks.where('sent = ?', true)
   end
   scope :accepted_invitations do |tasks|
		 tasks.where('sent = ? AND accepted = ?', true, true)
	 end
   scope :all do |tasks|
		 tasks
	 end
   member_action :send_invitation do
     req = RequestedInvitation.find(params[:id])
     person = Person.find_by_user_id(req.user_id)
     @invitation = Invitation.create!(:inviter_person_id => person.id, :invitation_active => true)
     begin
       UserMailer.invite_email(person.email, @invitation.invitation_unique_key).deliver
     rescue Exception => e
       puts "Email sending failed"
     end
     req.sent!
     redirect_to admin_requested_invitations_path
    end

	index do
     column "User id", :user_id, :sortable => false
     column "Invitation requested", :invitation_sent_date
     column "Sent invitation", :sent
     column "Accepted invitation", :accepted
     column "Action" do |request|
       link_to 'Send invitation code', send_invitation_admin_requested_invitation_path(request)
     end
  end

  
end
