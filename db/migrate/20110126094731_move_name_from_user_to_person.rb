class MoveNameFromUserToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :name, :string
    
    # transfer all names from user to person
    User.all.each do |user|
      puts "Moving user named: #{user.name}"
      user.person.name = user.name
      user.person.save!
    end
    
    remove_column :users, :name
  end

  def self.down
    add_column :users, :name, :string
    
    # transfer all names from person to user
    Person.all.each do |person|
      puts "Moving user named: #{person.name}"
      person.user.name = person.name
      person.user.save!
    end
    
    remove_column :people, :name
  end
end