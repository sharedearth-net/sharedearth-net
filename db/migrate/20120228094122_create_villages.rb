class CreateVillages < ActiveRecord::Migration
  def self.up
    create_table :villages do |t|
      t.string :name
      t.string :description
      t.string :street
      t.string :postcode
      t.string :state
      t.string :country
      t.integer :uid
      t.timestamps
    end
  end

  def self.down
    drop_table :villages
  end
end
