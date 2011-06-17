class PeopleNetworkController < ApplicationController
  before_filter :authenticate_user!
  # TODO add some verification who can destroy people network

  def destroy
    @people_network = PeopleNetwork.find(params[:id])
    trusted_person = @people_network.trusted_person
    EventLog.create_news_event_log(@people_network.person, @people_network.trusted_person, nil, EventType.trust_withdrawn)
    PeopleNetwork.involves(@people_network.person).involves(@people_network.trusted_person).limit(2).destroy_all
    @people_network.person.reputation_rating.decrease_trusted_network_count
    @people_network.trusted_person.reputation_rating.decrease_trusted_network_count
    redirect_to trusted_person
  end
end
