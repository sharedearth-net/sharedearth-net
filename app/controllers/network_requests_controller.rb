class NetworkRequestsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_network_request, :only => [ :destroy, :confirm ]
  before_filter :only_requester_or_trusted_person, :only => [ :destroy ]
  before_filter :only_trusted_person, :only => [ :confirm ]

  def create
    @trusted_person = Person.find(params[:trusted_person_id])
    current_person  = current_user.person

    if current_person.requested_trusted_relationship?(@trusted_person)
      current_person.requested_trusted_relationship(@trusted_person).confirm!
    else
      @trusted_person.request_trusted_relationship(current_person)
    end

		respond_to do |format|
			format.html { redirect_to @trusted_person }
			format.js
		end
  end
  
  def destroy
    @trusted_person = @network_request.trusted_person
    @network_request.destroy
    respond_to do |format|
			format.html { redirect_to @trusted_person }
			format.js
		end
  end
  
  def confirm
    @network_request.confirm!
    @trusted_person = @network_request.person
    respond_to do |format|
			format.html { redirect_to @trusted_person }
			format.js
		end
  end

  # used destroy for trusted_person too
  # def deny
  #   # @network_request.deny!
  #   # redirect_to(request_path(@network_request), :notice => I18n.t('messages.network_request.request_denied'))        
  # end

  private

  def get_network_request
    @network_request = NetworkRequest.find_by_id(params[:id])
    redirect_to dashboard_path if @network_request.nil?
  end

  def only_requester_or_trusted_person
    unless @network_request.trusted_person?(current_user.person) || @network_request.requester?(current_user.person)
      redirect_to(root_path, :alert => I18n.t('messages.only_requester_and_trusted_person_can_access'))
    end    
  end
  
  def only_trusted_person
    unless @network_request.trusted_person? current_user.person
      redirect_to(person_path(@network_request.trusted_person), :alert => I18n.t('messages.only_trusted_person_can_access'))
    end
  end
end
