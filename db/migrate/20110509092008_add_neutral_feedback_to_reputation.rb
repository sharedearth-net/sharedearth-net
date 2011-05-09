class AddNeutralFeedbackToReputation < ActiveRecord::Migration
  def self.up
    add_column :reputation_ratings, :neutral_feedback, :string
  end

  def self.down
    remove_column :reputation_ratings, :neutral_feedback
  end
end
