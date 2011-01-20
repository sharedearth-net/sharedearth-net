# define some commonly used mocks (like signed in user)

def mock_signedin_user(stubs = {})
  defaults = {:name => "Slobodan Kovacevic", :nickname => "basti"}
  @user = mock_model(User, defaults.merge(stubs))
end

