require 'spec_helper'

describe "items/show.html.erb" do
  
  def as_item_owner
    view.stub(:current_user).and_return(stub_model(User))
    @item.stub(:is_owner?).and_return(true)
  end
  
  def as_other_user_not_owner
    view.stub(:current_user).and_return(stub_model(User))
    @item.stub(:is_owner?).and_return(false)
  end
  
  before(:each) do
    @item = assign(:item, stub_model(Item,
      :item_type => "MyItemType",
      :name => "MyItemName",
      :description => "MyItemDescription",
      :owner_id => 1,
      :owner_type => "Owner Type"
    ))
  end

  it "renders attributes in <p>" do
    view.stub(:owner_only)
    render
    rendered.should match(/MyItemType/)
    rendered.should match(/MyItemName/)
    rendered.should match(/MyItemDescription/)
    # rendered.should match(/1/)
    # rendered.should match(/Owner Type/)
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
end
