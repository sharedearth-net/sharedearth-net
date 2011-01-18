class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :item_type
      t.string :name
      t.text :description
      t.integer :owner_id
      t.string :owner_type

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
