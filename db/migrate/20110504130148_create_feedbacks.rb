class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.integer :item_request_id
      t.integer :person_id
      t.string :feedback
      t.string :feedback_note
      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
