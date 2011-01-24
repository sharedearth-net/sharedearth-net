require 'spec_helper'

describe "items/index.html.erb" do
  before(:each) do
    assign(:items, [
      stub_model(Item,
        :item_type => "MyItemType",
        :name => "MyItemName",
        :description => "MyText",
        :owner_id => 1,
        :owner_type => "Owner Type"
      ),
      stub_model(Item,
        :item_type => "MyItemType",
        :name => "MyItemName",
        :description => "MyText",
        :owner_id => 1,
        :owner_type => "Owner Type"
      )
    ])
  end

  it "renders a list of items" do
    render
    assert_select "tr>td", :text => "MyItemType".to_s, :count => 2
    assert_select "tr>td", :text => "MyItemName".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # assert_select "tr>td", :text => 1.to_s, :count => 2
    # assert_select "tr>td", :text => "Owner Type".to_s, :count => 2
  end
end
