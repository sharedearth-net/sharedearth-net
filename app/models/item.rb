class Item < ActiveRecord::Base
  include PaperclipWrapper

  STATUS_NORMAL  = 10.freeze
  STATUS_LOST    = 20.freeze
  STATUS_DAMAGED = 30.freeze

  STATUSES = {
    STATUS_NORMAL     => 'normal',
    STATUS_LOST       => 'lost',
    STATUS_DAMAGED    => 'damaged'
  }
  
  STATUSES_VISIBLE_TO_OTHER_USERS = [ STATUS_NORMAL, STATUS_DAMAGED ]
  REQUESTABLE_STATUSES = [ STATUS_NORMAL ]
  
  has_many :item_requests
  belongs_to :owner, :polymorphic => true

  has_attachment :photo,
                 :styles => {
                   :large => "600x600>",
                   :medium => "300x300>",
                   :small => "100x100>",
                   :square => "50x50#"
                  },
                 :default_url => "/images/noimage-:style.png"

  # has_attached_file :photo,
  #                   :styles => {
  #                     :large => "600x600>",
  #                     :medium => "300x300>",
  #                     :small => "100x100>",
  #                     :square => "50x50#"
  #                    },
  #                   :storage => :s3,
  #                   :s3_credentials => S3_CREDENTIALS,
  #                   :path => "item-photos/:id-:basename-:style.:extension",
  #                   :default_url => "/images/noimage-:style.png"                    

  validates_presence_of :item_type, :name, :owner_id, :owner_type, :status
  validates_inclusion_of :status, :in => STATUSES.keys, :message => " must be in #{STATUSES.values.join ', '}"

  # validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 1.megabyte
  validates_attachment_content_type :photo, :content_type => /image\//
  
  scope :without_deleted, :conditions => { :deleted_at => nil }
  scope :only_normal, :conditions => { :status => STATUS_NORMAL }
  scope :only_lost, :conditions => { :status => STATUS_LOST }
  scope :only_damaged, :conditions => { :status => STATUS_DAMAGED }
  scope :visible_to_other_users, where("status IN (#{STATUSES_VISIBLE_TO_OTHER_USERS.join(",")})")
  
  def is_owner?(entity)
    self.owner == entity
  end
  
  def deleted?
    !deleted_at.nil?
  end
  
  def delete
    self.deleted_at = Time.zone.now
    save!
  end

  def restore
    self.deleted_at = nil
    save!
  end

  # #######
  # Status related methods
  # #######

  def status_name
    STATUSES[status]
  end

  def normal?
    self.status == STATUS_NORMAL
  end

  def lost?
    self.status == STATUS_LOST
  end

  def damaged?
    self.status == STATUS_DAMAGED
  end

  def normal!
    self.status = STATUS_NORMAL
    save!
  end

  def lost!
    self.status = STATUS_LOST
    save!
  end

  def damaged!
    self.status = STATUS_DAMAGED
    save!
  end
  
  def can_be_requested?
    REQUESTABLE_STATUSES.include? self.status
  end
end
