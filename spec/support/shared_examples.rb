shared_examples_for "requesting a deleted item" do
  it "should redirect the 'index' action" do
    response.should redirect_to items_path
  end

  it "should tell the user that the item has been deleted" do
    flash[:alert].should eql(I18n.t('messages.items.is_deleted'))
  end
end

shared_examples_for "requesting a hidden item" do
  it "should redirect the 'index' action" do
    response.should redirect_to items_path
  end

  it "should tell the user that the item has been deleted" do
    flash[:alert].should eql(I18n.t('messages.items.is_not_available'))
  end
end
