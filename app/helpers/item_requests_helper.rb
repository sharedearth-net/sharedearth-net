module ItemRequestsHelper
  def feedback_box_colour(feedback)
    case feedback.to_i
      when Feedback::FEEDBACK_POSITIVE
        html = "<div class=\"feedback positive-feedback\"></div>"
      when Feedback::FEEDBACK_NEGATIVE
        html = "<div class=\"feedback negative-feedback\"></div>"
      when Feedback::FEEDBACK_NEUTRAL
        html = "<div class=\"feedback neutral-feedback\"></div>"
      else
        html = ""
    end
    html.html_safe
  end
  
  def item_request_completed_sentence(item_request)
    gifter        =  link_to item_request.gifter.first_name, person_path(item_request.gifter), :class => "capitalize positive"
    item          = link_to item_request.item.item_type, item_path(item_request.item), :class => "positive"
    requester     = link_to item_request.requester.first_name, person_path(item_request.requester), :class => "capitalize positive"
    
    case item_request.item.purpose
      when Item::PURPOSE_SHARE
        html = "#{gifter} shared their #{item} with #{requester}"
      when Item::PURPOSE_GIFT
        html = "#{gifter} gifted their #{item} to #{requester}"
      when Item::PURPOSE_SHAREAGE
        html = "#{gifter} shareaged their #{item} to #{requester}"
      else
        html = ""
    end
    html.html_safe
  end
end
