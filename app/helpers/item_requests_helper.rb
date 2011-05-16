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
end
