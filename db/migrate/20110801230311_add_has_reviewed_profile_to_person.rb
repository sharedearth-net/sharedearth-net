class AddHasReviewedProfileToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :has_reviewed_profile, :boolean, :default => false
  end

  def self.down
    remove_column :people, :has_reviewed_profile
  end
end
