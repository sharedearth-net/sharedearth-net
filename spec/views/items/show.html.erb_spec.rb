require 'spec_helper'

describe "items/show.html.erb" do

  let(:signedin_user) { Factory(:person) }
  
  def as_item_owner
    view.stub(:current_user).and_return(stub_model(User))
    @item.stub(:is_owner?).and_return(true)
  end
  
  def as_other_user_not_owner
    view.stub(:current_user).and_return(stub_model(User))
    @item.stub(:is_owner?).and_return(false)
  end
  
  before(:each) do
    stub_template "shared/_trust_profile.html.erb" => "Trust profile"
    view.stub(:current_user).and_return(signedin_user.user)

    @item = Factory(:item, :owner => signedin_user)
    @item.stub(:available?).and_return(true)
  end

  it "renders attributes in <p>" do
    view.stub(:owner_only)
    render
    #rendered.should match(/Bike/)
    #rendered.should match(/Mountainbike/)
    #rendered.should match(/Big beautifyl bike/)
  end
  
  it "should render edit link to item owner" do
    as_item_owner
    render
    rendered.should have_selector("a", :href => edit_item_path(@item))
  end

  it "should not render edit link to non-owner" do
    as_other_user_not_owner
    render
    rendered.should_not have_selector("a", :href => edit_item_path(@item))
  end

  it "should render 'mark as lost' link to item owner" do
    as_item_owner
    render
    rendered.should have_selector("a", :href => mark_as_lost_item_path(@item))
  end

  it "should not render 'mark as lost' link to non-owner" do
    as_other_user_not_owner
    render
    rendered.should_not have_selector("a", :href => mark_as_lost_item_path(@item))
  end

  it "should render 'mark as damaged' link to item owner" do
    as_item_owner
    render
    rendered.should have_selector("a", :href => mark_as_damaged_item_path(@item))
  end

  it "should not render 'mark as damaged' link to non-owner" do
    as_other_user_not_owner
    render
    rendered.should_not have_selector("a", :href => mark_as_damaged_item_path(@item))
  end

  it "should render 'delete' link" do
    as_item_owner
    render
    rendered.should have_selector("a", :href => item_path(@item))
  end
  
  it "should not render 'delete' link if item is currently shared" do
    as_item_owner
    @item.stub(:available?).and_return(false)
    render
    rendered.should_not have_selector("a", :href => item_path(@item))
  end
  
  describe "for lost item" do
    before do
      @item.status = Item::STATUS_LOST
    end
    
    it "should render 'mark as found' link" do
      as_item_owner
      render
      rendered.should have_selector("a", :href => mark_as_normal_item_path(@item))
    end
    
    it "should not render 'mark as found' link if item is not lost" do
      as_item_owner
      @item.stub(:lost?).and_return(false)
      render
      rendered.should_not have_selector("a", :href => mark_as_normal_item_path(@item))
    end
  end

  describe "for damaged item" do
    before do
      @item.status = Item::STATUS_DAMAGED
    end
    
    it "should render 'mark as repaired' link" do
      as_item_owner
      render
      rendered.should have_selector("a", :href => mark_as_normal_item_path(@item))
    end
    
    it "should not render 'mark as repaired' link if not damaged" do
      as_item_owner
      @item.stub(:damaged?).and_return(false)
      render
      rendered.should_not have_selector("a", :href => mark_as_normal_item_path(@item))
    end
  end
end
