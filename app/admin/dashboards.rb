ActiveAdmin.register_page "Dashboard" do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendererd within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  content :title => "Dashboard" do

    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span "Welcome to Active Admin. This is the default dashboard page."
        small "To add dashboard sections, checkout 'app/admin/dashboards.rb'"
      end
    end
    
    columns do
      if ActiveRecord::Base.connection.table_exists?('settings') && Settings.invitations.to_s == 'true'
        column do
          panel "Send an invitation via email" do
             ul do
               render 'invite'
             end
          end
        end
      end

      column do
        panel "Settings" do
          ul do
            render 'settings' # => this will render /app/views/admin/dashboard/_settings.html.erb
          end
        end

        panel "New 10 Users" do
          ul do
            'Feature coming soon'
          end
        end

        panel "Top 10 by activity" do
          ul do
            'Feature coming soon'
          end
        end
      end
    end
  end
end
