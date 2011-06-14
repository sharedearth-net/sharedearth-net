class PeopleNetworkRequestsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_people_network_request, :only => [ :destroy, :confirm ]
  before_filter :only_requester_or_trusted_person, :only => [ :destroy ]
  before_filter :only_trusted_person, :only => [ :confirm ]

  def create
    @trusted_person = Person.find(params[:trusted_person_id])
    if @trusted_person.request_trusted_relationship(current_user.person)
      redirect_to(@trusted_person, :notice => I18n.t('messages.people.requested_trusted_relationship'))
    else
      # TODO: handle this better (should not happen)
      redirect_to(@trusted_person)
    end  
  end
  
  def destroy
    trusted_person = @people_network_request.trusted_person
    @people_network_request.destroy
    redirect_to(trusted_person, :notice => I18n.t('messages.people_network_request.destroy'))
  end
  
  def confirm
    @people_network_request.confirm!
    redirect_to(@people_network_request.trusted_person, {:notice => I18n.t('messages.people_network_request.request_confirmed')})
  end

  # used destroy for trusted_person too
  # def deny
  #   # @people_network_request.deny!
  #   # redirect_to(request_path(@people_network_request), :notice => I18n.t('messages.people_network_request.request_denied'))        
  # end

  private
  def get_people_network_request
    @people_network_request = PeopleNetworkRequest.find(params[:id])
  end

  def only_requester_or_trusted_person
    unless @people_network_request.trusted_person?(current_user.person) || @people_network_request.requester?(current_user.person)
      redirect_to(root_path, :alert => I18n.t('messages.only_requester_and_trusted_person_can_access'))
    end    
  end
  
  def only_trusted_person
    unless @people_network_request.trusted_person? current_user.person
      redirect_to(person_path(@people_network_request.trusted_person), :alert => I18n.t('messages.only_trusted_person_can_access'))
    end
  end
end
