class AddLoginAuthorization < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :encrypted_password, :string
    add_column :users, :person_id, :integer
    add_column :users, :verified_email, :boolean, :default => 0, :null => false
  end
end
