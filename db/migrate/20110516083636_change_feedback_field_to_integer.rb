class ChangeFeedbackFieldToInteger < ActiveRecord::Migration
  def self.up
    feedbacks = Feedback.all
    feedbacks.each do |f|
      case f.feedback
        when 'positive'
          f.feedback = Feedback::FEEDBACK_POSITIVE
        when 'negative'
          f.feedback = Feedback::FEEDBACK_NEGATIVE
        when 'neutral'
          f.feedback = Feedback::FEEDBACK_NEUTRAL
        else
          #    
      end
      f.save!
    end
    change_table :feedbacks do |t|
      t.change :feedback, :integer
    end
  end

  def self.down
  end
end
