

FACEBOOK_INFO = {
  "id" => "12345",
  "link" => "http://facebook.com/john_doe",
  "email" => "user@example.com",
  "name" => "John",
  "website" => "http://www.example.com"
}

Before("@omniauth_test") do
  OmniAuth.config.test_mode = true
  # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
  OmniAuth.config.mock_auth[:facebook] = {
      "uid" => "12345",
      "provider" => "facebook",
      "user_info" => { "nickname" => "Johny", "name" => "John", "email" => "user@example.com"},
      "credentials" => { "token" => "101448083266993|e988f10d01ea27bff083648b.1-625817457|vbqk5KMmrxogpCzR9A2JFA_KEBg" },
      "extra" => { "user_hash" => FACEBOOK_INFO }
  }
end

After("@omniauth_test") do
  OmniAuth.config.test_mode = false
end


def omniauth_mock_facebook
  OmniAuth.config.test_mode = true
  # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
  OmniAuth.config.mock_auth[:facebook] = {
      "uid" => "12345",
      "provider" => "facebook",
      "user_info" => { "nickname" => "Johny", "name" => "John"},
      "credentials" => { "token" => "101448083266993|e988f10d01ea27bff083648b.1-625817457|vbqk5KMmrxogpCzR9A2JFA_KEBg" },
      "extra" => { "user_hash" => FACEBOOK_INFO }
  }
end

def omniauth_mock_facebook_with_uid(uid)
  OmniAuth.config.test_mode = true
  # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
  OmniAuth.config.mock_auth[:facebook] = {
      "uid" => uid,
      "provider" => "facebook",
      "user_info" => { "nickname" => "Johny", "name" => "John"},
      "credentials" => { "token" => "101448083266993|e988f10d01ea27bff083648b.1-625817457|vbqk5KMmrxogpCzR9A2JFA_KEBg" },
      "extra" => { "user_hash" => FACEBOOK_INFO }
  }
end
