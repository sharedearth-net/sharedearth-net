# define some commonly used mocks (like signed in user)

module UserMocks
  def generate_mock_user_with_person(stubs = {})
    defaults = {:name => "Slobodan Kovacevic", 
                :nickname => "basti", 
                :person => mock_person, 
                :avatar => "http://graph.facebook.com/basti/picture"}
    mock_model(User, defaults.merge(stubs))
  end
  
  def mock_person_for_user(user, stubs = {})
    mock_person({:user => user, :user_id => user.id}.merge(stubs))
  end
  
  def mock_person(stubs = {})
    defaults = {:authorised_account => true, :accepted_tc => true, :accepted_pp => true}
    Factory(:person, defaults.merge(stubs))
  end
end
