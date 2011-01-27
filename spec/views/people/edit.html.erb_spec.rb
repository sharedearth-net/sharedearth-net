require 'spec_helper'

describe "people/edit.html.erb" do

  before do
    @person = assign(:person, stub_model(Person,
      :name => "Slobodan Kovacevic"
    ))
  end

  it "renders the edit person form" do
    render

    assert_select "form", :action => person_path(@person), :method => "post" do
      assert_select "input#person_name", :name => "person[name]"
    end
  end

end


