class Item < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true

  validates_presence_of :item_type, :name, :description, :owner_id, :owner_type
end
