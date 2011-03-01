require 'spec_helper'

describe PeopleController do
  
  let(:signedin_user) { generate_mock_user_with_person }
  let(:mock_person)   { mock_model(Person).as_null_object }
  let(:mock_items)    { [ mock_model(Item, :name => "Item1").as_null_object, mock_model(Item, :name => "Item2").as_null_object ] }
  let(:mock_item_requests)    { [ mock_model(ItemRequest).as_null_object, mock_model(ItemRequest).as_null_object ] }
  
  it_should_require_signed_in_user_for_actions :show, :edit, :update
  
  describe "for signed in member" do
    before do
      sign_in_as_user(signedin_user)
    end

    describe "GET show" do
      before do
        mock_person.stub(:items).and_return(mock_items)
        mock_person.stub(:unanswered_requests).and_return(mock_item_requests)
        Person.stub(:find).with("37") { mock_person }
        get :show, :id => "37"
      end
      
      it "assigns the requested person as @person" do
        assigns(:person).should be(mock_person)
      end
      
      it "should render show template" do
        response.should render_template("show")
      end
      
      it "should assign person's items as @items" do
        assigns(:items).should == mock_person.items
      end

      it "should assign person's unanswered requests as @unanswered_requests" do
        assigns(:unanswered_requests).should == mock_person.unanswered_requests
      end

    end
    
    describe "GET edit" do

      before do
        mock_person.stub(:items).and_return(mock_items)
        mock_person.stub(:belongs_to?).and_return(true)
        Person.stub(:find).with("37") { mock_person }
      end
      
      it "assigns the requested person as @person" do
        get :edit, :id => "37"
        assigns(:person).should be(mock_person)
      end
      
      it "should render show template" do
        get :edit, :id => "37"
        response.should render_template("edit")
      end

      it "should allow access only if person being modified is currently signed in" do
        mock_person.should_receive(:belongs_to?).with(signedin_user).and_return(true)
        get :edit, :id => "37"

        assigns(:person).should == mock_person
      end

      it "shouldn't allow users to edit other's persons" do
        mock_person.should_receive(:belongs_to?).with(signedin_user).and_return(false)
        get :edit, :id => "37"

        flash[:alert].should eql(I18n.t('messages.you_cannot_edit_others'))
        response.should redirect_to(root_path)
      end
    end

    describe "PUT update" do

      before do
        mock_person.stub(:belongs_to?).and_return(true)
        Person.stub(:find).with("37") { mock_person }
      end
      
      describe "with valid params" do

        it "updates the requested person" do
          mock_person.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :person => {'these' => 'params'}
        end
        
        it "assigns the requested person as @person" do
          mock_person.stub(:update_attributes).and_return(true)
          put :update, :id => "37"
          assigns(:person).should be(mock_person)
        end

        it "redirects to the person page (profile)" do
          mock_person.stub(:update_attributes).and_return(true)
          put :update, :id => "37"
          response.should redirect_to(person_path(mock_person))
        end

        it "should allow access only if person being updated is currently signed in" do
          mock_person.should_receive(:belongs_to?).with(signedin_user).and_return(true)
          put :update, :id => "37"
        
          assigns(:person).should be(mock_person)
        end

        it "shouldn't allow users to update other's persons" do
          mock_person.should_receive(:belongs_to?).with(signedin_user).and_return(false)
          put :update, :id => "37"

          flash[:alert].should eql(I18n.t('messages.you_cannot_edit_others'))
          response.should redirect_to(root_path)
        end
      
      end
      
      describe "with invalid params" do
      
        it "assigns the person as @person" do
          mock_person.stub(:update_attributes).and_return(false)
          put :update, :id => "37"
          assigns(:person).should be(mock_person)
        end
      
        it "re-renders the 'edit' template" do
          mock_person.stub(:update_attributes).and_return(false)
          put :update, :id => "37"
          response.should render_template("edit")
        end
      
      end

    end

  end

end
