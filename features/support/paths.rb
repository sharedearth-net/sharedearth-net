module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      root_path
    when /the new item page/
      new_item_path
    when /the invitations page/
      invitations_path  
    when /the dashboard page/
      dashboard_path
    when /the edit page of (.+)/    
      edit_polymorphic_path(model($1))
    when /the show page of (.+)/    
      polymorphic_path(model($1))
    when /items/
      items_path
    when /"(.+)"'s profile page/
      person = Person.find_by_name($1)
      person_path(person)
    when /others page/
      others_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    
    #For rest of the controllers index page that are not defined
    #Example: units page
    when /([^\"]*) page/
      "#{$1}"

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
