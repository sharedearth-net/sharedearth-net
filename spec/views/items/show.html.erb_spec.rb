require 'spec_helper'

describe "items/show.html.erb" do

  let(:signedin_user) { generate_mock_user_with_person }
  
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
    view.stub(:current_user).and_return(signedin_user)

    @item = assign(:item, stub_model(Item,
      :item_type => "MyItemType",
      :name => "MyItemName",
      :description => "MyItemDescription",
      :owner_id => 1,
      :owner_type => "Person",
      :status => Item::STATUS_NORMAL
    ))
  end

  it "renders attributes in <p>" do
    view.stub(:owner_only)
    render
    rendered.should match(/MyItemType/)
    rendered.should match(/MyItemName/)
    rendered.should match(/MyItemDescription/)
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
  
  describe "for lost item" do
    before do
      @item.status = Item::STATUS_LOST
    end
    
    it "should render 'mark as found' link" do
      as_item_owner
      render
      rendered.should have_selector("a", :href => mark_as_normal_item_path(@item))
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
  end
end
