require 'spec_helper'

describe "item_requests/new.html.erb" do
  before do
    assign(:item_request, stub_model(ItemRequest,
      :description => "MyText"#,
      # :owner_id => 1,
      # :owner_type => "MyString"
    ).as_new_record)
  end

  it "renders new item form" do
    render

    assert_select "form", :action => requests_path, :method => "post" do
      # assert_select "input#item_name", :name => "item[name]"
      assert_select "textarea#item_request_description", :name => "item_request[description]"
      # assert_select "input#item_owner_id", :name => "item[owner_id]"
      # assert_select "input#item_owner_type", :name => "item[owner_type]"
    end
  end
end
