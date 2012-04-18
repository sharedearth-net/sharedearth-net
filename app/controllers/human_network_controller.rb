class HumanNetworkController < ApplicationController
  before_filter :authenticate_user!
  # TODO add some verification who can destroy people network

  def destroy
    @human_network = HumanNetwork.find(params[:id])
    @trusted_person = @human_network.trusted_person
    if @human_network.entity == current_user.person
      EventLog.create_news_event_log(@human_network.entity, @human_network.person, nil, EventType.trust_withdrawn, @human_network)
    else
      EventLog.create_news_event_log(@human_network.person, @human_network.entity, nil, EventType.trust_withdrawn, @human_network)
    end
    HumanNetwork.involves(@human_network.entity).involves(@human_network.person).limit(2).destroy_all
    @human_network.entity.reputation_rating.decrease_trusted_network_count
    @human_network.person.reputation_rating.decrease_trusted_network_count
    respond_to do |format|
			format.html { redirect_to @trusted_person }
			format.js
		end
  end
end
