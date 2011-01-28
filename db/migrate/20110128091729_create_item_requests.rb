class CreateItemRequests < ActiveRecord::Migration
  def self.up
    create_table :item_requests do |t|
      t.integer :requester_id
      t.string :requester_type
      t.integer :gifter_id
      t.string :gifter_type
      t.references :item
      t.text :description
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :item_requests
  end
end
