class ChangeUsersPeopleRelation < ActiveRecord::Migration
  def up
    User.find_each do |user|
      person = Person.where(:user_id => user.id).first
      user.update_attribute(:person_id, person.id)
    end
    remove_column :people, :user_id
  end

  def down
    add_column :people, :user_id, :integer
  end
end
