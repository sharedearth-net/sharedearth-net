class CreatePersonGiftActRatings < ActiveRecord::Migration
  def self.up
    create_table :person_gift_act_ratings do |t|
      t.integer :person_id
      t.float :gift_act_rating
      t.timestamps
    end
  end

  def self.down
    drop_table :person_gift_act_ratings
  end
end
