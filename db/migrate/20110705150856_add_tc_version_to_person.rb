class AddTcVersionToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :tc_version, :decimal, :default => 1.0
    add_column :people, :pp_version, :decimal, :default => 1.0
  end

  def self.down
  end
end
