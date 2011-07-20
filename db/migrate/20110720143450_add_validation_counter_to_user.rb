class AddValidationCounterToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :validations_failed, :integer, :default => 0
  end

  def self.down
    remove_column :users, :validations_failed
  end
end
