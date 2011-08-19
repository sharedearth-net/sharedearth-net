class ChangeFeedbackNoteOnFeedback < ActiveRecord::Migration
  def self.up
    change_column :feedbacks, :feedback_note, :text, :limit => nil
  end

  def self.down
    change_column :feedbacks, :feedback_note, :string
  end
end
