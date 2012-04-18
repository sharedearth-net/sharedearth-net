# define some commonly used mocks (like signed in user)

module UserMocks
  def generate_mock_user_with_person(stubs = {})
    defaults = {:name => "Slobodan Kovacevic", 
                :nickname => "basti", 
                :person => mock_person, 
                :avatar => "http://graph.facebook.com/basti/picture", 
								:uid => '111111'}
    mock_model(User, defaults.merge(stubs))
  end

  def generate_mock_user_with_firstimer_person(stubs = {})
    defaults = {:name => "Slobodan Kovacevic", 
                :nickname => "basti", 
                :person => mock_new_person, 
                :avatar => "http://graph.facebook.com/basti/picture", 
								:uid => '111111'}
    mock_model(User, defaults.merge(stubs))
  end
  
  def mock_person_for_user(user, stubs = {})
    mock_person({:user => user, :user_id => user.id}.merge(stubs))
  end
  
  def mock_person(stubs = {})
    defaults = {:authorised_account => true, :accepted_tc => true, :accepted_tr => true, :accepted_pp => true}
    Factory(:person, defaults.merge(stubs))
  end

  def mock_new_person(stubs = {})
    defaults = {:authorised_account => true, :accepted_tc => false, :accepted_tr => false, :accepted_pp => false}
    Factory(:person, defaults.merge(stubs))
  end
end
