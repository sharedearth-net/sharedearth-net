# define some commonly used mocks (like signed in user)

module UserMocks
  def mock_signedin_user(stubs = {})
    defaults = {:name => "Slobodan Kovacevic", :nickname => "basti", :person => mock_person}
    # @user = mock_model(User, defaults.merge(stubs))
    mock_model(User, defaults.merge(stubs))
  end
  
  def mock_person_for_user(user, stubs = {})
    mock_person({:user => user, :user_id => user.id}.merge(stubs))
  end
  
  def mock_person(stubs = {})
    defaults = {}
    mock_model(Person, defaults.merge(stubs))
  end
end
