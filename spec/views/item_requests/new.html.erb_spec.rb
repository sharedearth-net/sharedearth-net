require 'spec_helper'

describe "item_requests/new.html.erb" do

  let(:stub_item_request) {
    stub_model(ItemRequest,
      :description => "MyDescription",
      :item_id => 1,
      :item => stub_model(Item, :name => "MyItemName"),
      :gifter_id => 2,
      :gifter_type => "Person",
      :gifter => stub_model(Person, :name => "Slobodan Kovacevic")
    ).as_new_record
  }

  before do
    assign(:item_request, stub_item_request)
  end

  it "renders new item form" do
    render

    assert_select "form", :action => requests_path, :method => "post" do
      assert_select "textarea#item_request_description", :name => "item_request[description]"
      assert_select "input#item_request_item_id", :name => "item_request[item_id]"
      # assert_select "input#item_owner_id", :name => "item[owner_id]"
      # assert_select "input#item_owner_type", :name => "item[owner_type]"
    end
  end

  it "should display item name and gifter name" do
    render
    rendered.should contain(stub_item_request.item.name)
    rendered.should contain(stub_item_request.gifter.name)
  end
end
