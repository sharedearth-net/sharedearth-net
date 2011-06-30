class AddTcAcceptanceToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :accepted_tc_and_pp, :boolean, :default => false
    
    #Add agreed terms and conditions to every exsisting person
    current_people = Person.all
    current_people.each { |person| person.update_attributes(:accepted_tc_and_pp => true) }
  end

  def self.down
    remove_column :people, :accepted_tc_and_pp
  end
end
