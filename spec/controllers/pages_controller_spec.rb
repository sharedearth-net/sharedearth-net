require 'spec_helper'

describe PagesController do
  render_views

  let(:mock_item_request) { mock_model(ItemRequest).as_null_object }
  let(:mock_person) { Factory(:person) }
  let(:signedin_user) { Factory(:person).user }
  let(:mock_villages) {[mock_model(Village).as_null_object, mock_model(Village).as_null_object]}
  let(:mock_villages_id) {[1001,1002]}
  let(:mock_items)    { [ mock_model(Item, :name => "Item1", :owner => signedin_user.person).
                        as_null_object, mock_model(Item, :name => "Item2").as_null_object ] }
  let(:mock_entities)    { [ mock_model(Entity, :id => 2).as_null_object, mock_model(Entity, :id => 3).as_null_object ] }
  let(:mock_entity)    { mock_model(Entity).as_null_object }
  let(:mock_village)    { mock_model(Village).as_null_object }


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
        signedin_user.stub(:person).and_return(mock_person)
        sign_in_as_user(signedin_user)
      end

      it "should render the right layout" do
        get :about
        response.should render_template 'layouts/application'
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
        Entity.stub(:find_by_id).with("37").and_return(mock_entity)
        mock_entity.stub(:specific_entity).and_return(mock_village)
        #ResourceNetwork.stub(:items_belong_to).with(mock_village).and_return(mock_items)
        #Member.stub(:person_villages).with(mock_person).and_return(mock_villages)
        Village.stub(:belongs_to_person).with(mock_person).and_return(mock_villages_id)
        get :network, :entity_id => "37"
      end

      it "should be successful" do
        response.should render_template("pages/network")
      end

      it "should be successful" do
        response.should be_success
      end

      it "should be successful" do
        #Penging test for new items generation
        #assigns(:items).should eq(mock_items)
      end

      it "assigns the current person's items as @items" do
        #Pending test
        #assigns(:items).should eq(mock_items)
      end

    end

    describe "GET network" do
      before do
        mock_person.stub_chain(:trusted_friends_items, :sort_by).and_return{mock_items}
        signedin_user.stub(:network_activity).and_return{mock_event}
        Person.stub(:find_by_id).with("37").and_return{mock_person}
        get :network, :id => "37", :type => "trusted"
      end

      it "should return list of items in my network withouth hidden" do
        #Pending test
        #assigns(:items).should == mock_person.trusted_friends_items("trusted").without_hidden.sort_by{|i| i.item_type.downcase}
      end
    end
  end
end
