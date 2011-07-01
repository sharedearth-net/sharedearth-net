require 'spec_helper'

describe "items/index.html.erb" do
  before(:each) do
    assign(:items, [Factory(:item), Factory(:item)]) 
  end

  it "renders a list of items" do
    render
    #rendered.should contain("Mountainbike"), :count => 2
    #rendered.should contain("Bike"), :count => 2
    #rendered.should contain("Big beautifyl bike"), :count => 2
  end
end
