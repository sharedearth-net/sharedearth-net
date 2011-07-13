class ChangeTcAndPpAcceptance < ActiveRecord::Migration
  def self.up
    rename_column :people, :accepted_tc_and_pp, :accepted_tc
  end

  def self.down
    rename_column :people,  :accepted_tc, :accepted_tc_and_pp
  end
end
