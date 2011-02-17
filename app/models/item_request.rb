class ItemRequest < ActiveRecord::Base
  STATUS_REQUESTED = 10.freeze
  STATUS_ACCEPTED  = 20.freeze
  STATUS_COMPLETED = 30.freeze
  STATUS_REJECTED  = 40.freeze
  STATUS_CANCELED  = 50.freeze
  STATUS_COLLECTED  = 60.freeze

  STATUSES = {
    STATUS_REQUESTED  => 'requested',
    STATUS_ACCEPTED   => 'accepted',
    STATUS_COMPLETED  => 'completed',
    STATUS_REJECTED  => 'rejected',
    STATUS_CANCELED  => 'canceled',
    STATUS_COLLECTED  => 'collected'
  }
  
  ACTIVE_STATUSES = [ STATUS_REQUESTED, STATUS_ACCEPTED, STATUS_COLLECTED ]
  
  belongs_to :item
  belongs_to :requester, :polymorphic => true
  belongs_to :gifter, :polymorphic => true

  scope :involves, lambda { |entity| where("(requester_id = ? AND requester_type = ?) OR (gifter_id = ? AND gifter_type = ?) ", entity.id, entity.class.to_s, entity.id, entity.class.to_s) }
  scope :active, where("status IN (#{ACTIVE_STATUSES.join(",")})")
  
  # validates_presence_of :description
  validates_presence_of :requester_id, :requester_type
  validates_presence_of :gifter_id, :gifter_type
  validates_presence_of :item_id, :status
  validates_inclusion_of :status, :in => STATUSES.keys, :message => " must be in #{STATUSES.values.join ', '}"

  def status_name
    STATUSES[status]
  end
  
  def requester?(requester)
    self.requester == requester
  end

  def gifter?(gifter)
    self.gifter == gifter
  end
  
  def accept!
    self.status = STATUS_ACCEPTED
    save!
  end

  def reject!
    self.status = STATUS_REJECTED
    save!
  end

  def cancel!
    self.status = STATUS_CANCELED
    save!
  end

  def collected!
    self.status = STATUS_COLLECTED
    save!
  end

  def complete!
    self.status = STATUS_COMPLETED
    save!
  end
end
