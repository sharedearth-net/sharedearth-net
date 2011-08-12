begin
  INVITATION_SYS_ON = (Settings.invitations == 'true' ? true : false)
rescue
  INVITATION_SYS_ON = false
end
