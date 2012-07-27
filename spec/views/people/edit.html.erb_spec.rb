require 'spec_helper'

describe "people/edit.html.erb" do

  before do
    @person = FactoryGirl.create(:person, :users => [FactoryGirl.create(:user)])
  end

  it "renders the edit person form" do
  
    view.stub!(:current_user).and_return(@person.users.first)
    render

    assert_select "form", :action => person_path(@person), :method => "post" do
      assert_select "input#person_name", :name => "person[name]"
    end
  end

end


