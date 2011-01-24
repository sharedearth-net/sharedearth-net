require 'spec_helper'

describe "items/new.html.erb" do
  before(:each) do
    assign(:item, stub_model(Item,
      :item_type => "MyString",
      :name => "MyString",
      :description => "MyText",
      :owner_id => 1,
      :owner_type => "MyString"
    ).as_new_record)
  end

  it "renders new item form" do
    render

    assert_select "form", :action => items_path, :method => "post" do
      assert_select "input#item_item_type", :name => "item[type]"
      assert_select "input#item_name", :name => "item[name]"
      assert_select "textarea#item_description", :name => "item[description]"
      # assert_select "input#item_owner_id", :name => "item[owner_id]"
      # assert_select "input#item_owner_type", :name => "item[owner_type]"
    end
  end
end
