class InvitationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:validate, :key, :purge]
  before_filter :admin_access, :only => [:index, :new, :create]
    
  def index
    @invitations = Invitation.all
  end

  def new
  end

  def create      
    invitations = params[:invitations].to_i
    items = params[:items].to_i
    
    redirect_to new_invitation_path, :notice => "Please enter correct data in fields" and return if (invitations <= 0  || items < 0)
    people = Person.with_items_more_than(items)
    @people_count = people.count
    @invitation_count = invitations * @people_count
    if params[:preview_button]
      render :action => 'new'
    else
      @invites = []
      invitations.times do |inv|
        @invites += people.collect { |person| Invitation.new(:inviter_person_id => person.id, :invitation_active => true) }
      end
      if @invites.each(&:save!)
        redirect_to invitations_path, :notice => "Successfully created invitations."
      else
        render :action => 'new'
      end
    end
  end
  
  def validate
   key = params[:key]
   unless key.empty?
     invitation = Invitation.find_by_invitation_unique_key(key)
     if !invitation.nil? && invitation.active?
        invitation.update_attributes(:invitee_person_id => current_user.person.id, :accepted_date => Time.now, :invitation_active => false)
        current_user.person.update_attributes(:authorised_account => true)
        current_user.inform_mutural_friends(session[:fb_token])
        redirect_to terms_path and return
     end
   end 
   redirect_to root_path, :notice => "The code you have provided is invalid or inactive" 
  end
  
  def purge
    current_user.destroy
    redirect_to signout_path
  end
      
  private
  
  def administrator?
    current_user.uid == '632021541' || current_user.uid == '1221401527'
  end
  
  def admin_access
    redirect_to dashboard_path, :notice => "Wrong url" if !administrator?
  end
  
end
