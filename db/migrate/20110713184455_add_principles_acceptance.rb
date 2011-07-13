class AddPrinciplesAcceptance < ActiveRecord::Migration
  def self.up
    add_column :people, :accepted_pp, :boolean, :default => false
  end

  def self.down
    remove_column :people, :accepted_pp
  end
end
