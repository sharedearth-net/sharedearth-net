require 'spec_helper'

describe PagesController do
  render_views

  let(:mock_item_request) { mock_model(ItemRequest).as_null_object }
  #let(:mock_item_requests) {[ mock_model(ItemRequest).as_null_object,  mock_model(ItemRequest).as_null_object] }
  let(:mock_person) { Factory(:person) }
  let(:signedin_user) { Factory(:person).user }
  let(:mock_villages) {[mock_model(Village).as_null_object, mock_model(Village).as_null_object]}
  let(:mock_villages_id) {[1001,1002]}
  let(:mock_items)    { [ mock_model(Item, :name => "Item1", :owner => signedin_user.person).
                        as_null_object, mock_model(Item, :name => "Item2").as_null_object ] }
  let(:mock_entities)    { [ mock_model(Entity, :id => 2).as_null_object, mock_model(Entity, :id => 3).as_null_object ] }
  let(:mock_entity)    { mock_model(Entity).as_null_object }
  let(:mock_village)    { mock_model(Village).as_null_object }
  let(:mock_specific_entity)    { mock_model(Village).as_null_object }
  let(:mock_item)    {  mock_model(Item).as_null_object }
  let(:mock_events) {mock_model(EventDisplay).as_null_object}


  it_should_require_signed_in_user_for_actions :dashboard

  describe "GET 'about'" do
    it "should be succesful" do
      get :about
      response.should be_success
    end

    it "should render the right template" do
      get :about
      response.should render_template :about
    end

    context "When the user is not logged in" do
      it "should render the right layout" do
        get :about
        response.should render_template 'layouts/shared_earth'
      end
    end

    context "When the user is logged in" do
      before do
        sign_in_as_user(signedin_user)
      end

      it "should render the right layout" do
        get :about
        pending "test is passing when run individually"
        #individuallyresponse.should render_template 'layouts/application'
      end
    end
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
      response.should render_template("pages/index")
    end
  end

  describe "as signed in user" do

    before do
      signedin_user.stub(:person).and_return(mock_person)
      mock_item.stub_chain(:photo, :url).and_return('item_image.gif')
      sign_in_as_user(signedin_user)
    end

    describe "GET 'dashboard'" do

      it "should be successful" do
        get :dashboard
        response.should be_success
        response.should render_template("pages/dashboard")
      end

      it "assigns the current person's active requests as @active_item_requests" do
        mock_item_requests = [Factory(:item_request), Factory(:item_request)]
        signedin_user.stub(:person).and_return(Factory(:person))
        signedin_user.person.stub(:active_item_requests) { mock_item_requests }
        signedin_user.person.stub(:received_network_requests) { [] }
        signedin_user.person.stub(:network_requests) { [] }
        signedin_user.person.stub(:activity_logs) { [] }
        signedin_user.person.stub(:news_feed) { [] }
        get :dashboard
        assigns(:active_item_requests).should eq(mock_item_requests)
      end

      it "should reset person email notification count" do
				mock_item_requests = [Factory(:item_request), Factory(:item_request)]
        signedin_user.stub(:person).and_return(Factory(:person))
        signedin_user.person.stub(:active_item_requests) { mock_item_requests }
        signedin_user.person.stub(:received_network_requests) { [] }
        signedin_user.person.stub(:network_requests) { [] }
        signedin_user.person.stub(:activity_logs) { [] }
        signedin_user.person.stub(:news_feed) { [] }
     		get :dashboard
        signedin_user.person.email_notifications_count?.should eql(0)
    end
    end


    describe "GET 'network'" do
      before do
        Entity.stub(:groups_with_person).with(mock_person).and_return(mock_entities)
        mock_entity.stub(:specific_entity).and_return(mock_village)
        #ResourceNetwork.stub(:items_belong_to).with(mock_village).and_return(mock_items)
        #Member.stub(:person_villages).with(mock_person).and_return(mock_villages)
        Village.stub(:belongs_to_person).with(mock_person).and_return(mock_villages_id)
      end

      it "should be successful" do
        get :network, :entity_id => "37"
        response.should render_template("pages/network")
      end

      it "should be successful" do
        get :network, :entity_id => "37"
        response.should be_success
      end
      context "trusted network" do
        before do
          mock_person.stub_chain(:trusted_friends_items, :without_hidden, :sort_by).and_return{[mock_item]}
          mock_person.stub_chain(:trusted_network_activity, :paginate).and_return{mock_events}
        end

        it "should assign items from  trusted network" do
          get :network, :entity_id => "37", :type => 'trusted'
          assigns(:items).should eq([mock_item])
        end

        it "should assign events from  trusted network" do
          get :network, :type => 'trusted'
          assigns(:events).should == mock_events
        end
      end
      context "entity" do
        before do
          Entity.stub(:find_by_id).with("37").and_return(mock_entity)
          ResourceNetwork.stub(:items_belong_to).with(mock_village).and_return([mock_item])
          mock_entity.stub_chain(:network_activity, :paginate).and_return(mock_events)
        end

        it "should be successful" do
          get :network, :entity_id => '37'
          assigns(:items).should eq([mock_item])
        end

        it "assigns events" do
          get :network, :entity_id => '37'
          assigns(:events).should eq(mock_events)
        end

      end

      context "own network" do
        before do
          ResourceNetwork.stub(:all_item_from).with(mock_entities).and_return([mock_item])
          mock_person.stub(:personal_network_items).and_return([mock_item])
          mock_person.stub_chain(:network_activity, :paginate).and_return(mock_events)
        end

        it "assigns items be successful" do
          get :network
          assigns(:items).should eq([mock_item])
        end

        it "assigns events" do
          get :network
          assigns(:events).should eq(mock_events)
        end

      end

    end

  end
end
