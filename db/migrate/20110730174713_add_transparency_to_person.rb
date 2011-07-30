class AddTransparencyToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :accepted_tr, :boolean, :default => false
  end

  def self.down
    remove_column :people, :accepted_tr
  end
end
