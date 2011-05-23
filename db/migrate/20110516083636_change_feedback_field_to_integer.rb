class ChangeFeedbackFieldToInteger < ActiveRecord::Migration
  def self.up
    add_column :feedbacks, :feedback_int, :integer
    feedbacks = Feedback.all
    feedbacks.each do |f|
      case f.feedback
        when 'positive'
          f.feedback_int = Feedback::FEEDBACK_POSITIVE
        when 'negative'
          f.feedback_int = Feedback::FEEDBACK_NEGATIVE
        when 'neutral'
          f.feedback_int = Feedback::FEEDBACK_NEUTRAL
        else
          #    
      end
      f.save!
    end
    remove_column :feedbacks, :feedback
    rename_column :feedbacks, :feedback_int, :feedback
  end

  def self.down
    remove_column :feedbacks, :feedback_int
  end
end
