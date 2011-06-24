class AddAuthorisedToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :authorised_account, :boolean, :default => false
    #Authorise all current persons registered
    people = Person.all
    people.each do |p|
        p.update_attributes(:authorised_account => true)
    end
  end

  def self.down
   remove_column :people, :authorised_account
  end
end
