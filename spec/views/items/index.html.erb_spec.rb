require 'spec_helper'

describe "items/index.html.erb" do
  before(:each) do
    assign(:items, [FactoryGirl.create(:item), FactoryGirl.create(:item)])
  end

  it "renders a list of items" do
    #Penging render list of items
    #render
    #rendered.should contain("Mountainbike"), :count => 2
    #rendered.should contain("Bike"), :count => 2
    #rendered.should contain("Big beautifyl bike"), :count => 2
  end
end
