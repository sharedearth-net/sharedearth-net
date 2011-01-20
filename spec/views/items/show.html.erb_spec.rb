require 'spec_helper'

describe "items/show.html.erb" do
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
    render
    rendered.should match(/MyItemType/)
    rendered.should match(/MyItemName/)
    rendered.should match(/MyItemDescription/)
    rendered.should match(/1/)
    rendered.should match(/Owner Type/)
  end
end
