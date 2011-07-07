class AddDetailsToPerson < ActiveRecord::Migration
  def self.up
   add_column :people, :location, :string
   add_column :people, :description, :text
  end

  def self.down
  end
end
