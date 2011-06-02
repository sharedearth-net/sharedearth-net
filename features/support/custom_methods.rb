def generate_uid(length=6)
    alphanumerics = ('0'..'9').to_a
    uid = alphanumerics.sort_by{rand}.to_s[0..length]

    # Ensure uniqueness of the token..
    generate_uid if User.find_by_uid(uid).nil?
end
