class Item < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true

  has_attached_file :photo,
                    :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :storage => :s3,
                    :s3_credentials => S3_CREDENTIALS,
                    :path => "item-photos/:id-:basename-:style.:extension",
                    :default_url => "/images/noimage-:style.png"
                    

  validates_presence_of :item_type, :name, :description, :owner_id, :owner_type

  # validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 1.megabyte
  validates_attachment_content_type :photo, :content_type => /image\//
  
  def is_owner?(entity)
    self.owner == entity
  end
end
