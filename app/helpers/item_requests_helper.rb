module ItemRequestsHelper
  def feedback_box_colour(feedback)
    case feedback
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
    gifter        = link_to_person(@item_request.gifter)
    gifter_you    = link_to_person(item_request.gifter, :downcase_you => true, :possessive => true, :class => "capitalize positive")
    item          = link_to @item_request.item.item_type, item_path(@item_request.item)
    requester     = link_to_person(@item_request.requester)
    requester_you = link_to_person(item_request.requester, :downcase_you => true, :possessive => true, :class => "capitalize positive")
    
    case item_request.item.purpose
      when Item::PURPOSE_SHARE
        if item_request.requester?(current_user.person)
          html = "<strong>You</strong> borrowed #{gifter}'s #{item}"
        else
          html = "<strong>#{requester}</strong> borrowed your #{item}"
        end
      when Item::PURPOSE_GIFT
        if item_request.requester?(current_user.person)
          html = "<strong>You</strong> received #{gifter}'s #{item}"
        else
          html = "<strong>You</strong> gifted your #{item} to #{requester}"
        end
      else
        html = ""
    end
    html.html_safe
  end
end
