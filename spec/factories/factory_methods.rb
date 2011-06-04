def create_or_return_user
  user ||= Factory(:user)
end

