module ApplicationHelper
  def owner_only(item, &block)
    content_tag(:div, :class => "owner_only", &block) if current_user && item.is_owner?(current_user.person)
  end
end
