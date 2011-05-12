class SetNeutralFeedbackToZero < ActiveRecord::Migration
  def self.up
    change_table :reputation_ratings do |t|
      t.change :neutral_feedback, :integer, :default => 0
    end
    people = Person.all
    people.each do | person |
      person.reputation_rating.update_attributes(:neutral_feedback => 0)
   end
  end

  def self.down
  end
end
