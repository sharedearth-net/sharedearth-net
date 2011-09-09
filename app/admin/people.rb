ActiveAdmin.register Person do
  index do
     column "Name", :name, :sortable => false
     column "Authorised", :authorised_account
     column "E-mail", :email
     column "Invitations count", :invitations_count
     default_actions
  end

		form do |f|
      f.inputs "Details" do
        f.input :name
        f.input :email, :label => "E-mail"
        f.input :invitations_count
      end
      f.buttons
    end
  
end
