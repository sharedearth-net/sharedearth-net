class AddDeletedAtToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :deleted_at, :datetime
  end

  def self.down
    remove_column :items, :deleted_at
  end
end
