class PeopleNetworkController < ApplicationController
  before_filter :authenticate_user!
  # TODO add some verification who can destroy people network

  def destroy
    @human_network = PeopleNetwork.find(params[:id])
    @trusted_person = @human_network.trusted_person
    if @human_network.person == current_user.person
      EventLog.create_news_event_log(@human_network.person, @human_network.trusted_person, nil, EventType.trust_withdrawn, @human_network)
    else
      EventLog.create_news_event_log(@human_network.trusted_person, @human_network.person, nil, EventType.trust_withdrawn, @human_network)
    end
    PeopleNetwork.involves(@human_network.person).involves(@human_network.trusted_person).limit(2).destroy_all
    @human_network.person.reputation_rating.decrease_trusted_network_count
    @human_network.trusted_person.reputation_rating.decrease_trusted_network_count
    respond_to do |format|
			format.html { redirect_to @trusted_person }
			format.js
		end
  end
end
