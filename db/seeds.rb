# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

entity_types = [
								{:id => 1, :name => 'Person'},
								{:id => 2, :name => 'Item'},
								{:id => 3, :name => 'Skill'},
								{:id => 4, :name => 'Village'},
								{:id => 5, :name => 'Community'},
								{:id => 6, :name => 'Project'},
								{:id => 7, :name => 'Trusted Person'},
								{:id => 8, :name => 'Mutual Person'}
							 ]

EntityType.delete_all

entity_types.each do |entity|
 et = EntityType.new(:entity_type_name => entity[:name])
 et.id = entity[:id]
 et.save!
end

AdminUser.create!(:email    => 'admin@senlocal.heroku.net', 
                  :password => 'password', 
                  :password_confirmation => 'password')

