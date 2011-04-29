class CreateReputationRatings < ActiveRecord::Migration
  def self.up
    create_table :reputation_ratings do |t|
      t.integer :person_id
      t.integer :gift_actions
      t.integer :distinct_people
      t.integer :total_actions
      t.integer :positive_feedback
      t.integer :negative_feedback
      t.integer :requests_received
      t.integer :requests_answered
      t.integer :trusted_network_count
      t.integer :activity_level

      t.timestamps
    end
  end

  def self.down
    drop_table :reputation_ratings
  end
end
