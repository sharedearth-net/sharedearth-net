class Invitation < ActiveRecord::Base
  attr_accessible :inviter_person_id, :invitation_unique_key, :invitation_active, :accepted_date, :invitee_person_id, :invitee_email
  before_create :generate_key
  belongs_to :person
  def generate_key(length=6)
    alphanumerics = ('0'..'9').to_a
    self.invitation_unique_key = alphanumerics.sort_by{rand}.to_s[0..length]

    # Ensure uniqueness of the token..
    generate_key unless Invitation.find_by_invitation_unique_key(self.invitation_unique_key).nil?
  end
  
  def active?
    self.invitation_active
  end
  
  def inactive?
    !self.invitation_active
  end
  
  def inviter 
    Person.find_by_id(self.inviter_person_id) || 'Admin'
  end
  
  def invitee
    Person.find_by_id(self.invitee_person_id)
  end
end
