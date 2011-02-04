class ItemRequest < ActiveRecord::Base
  STATUS_REQUESTED = 10.freeze
  STATUS_ACCEPTED  = 20.freeze
  STATUS_COMPLETED = 30.freeze

  STATUSES = {
    STATUS_REQUESTED  => 'requested',
    STATUS_ACCEPTED   => 'accepted',
    STATUS_COMPLETED  => 'completed'
  }
  
  belongs_to :item
  belongs_to :requester, :polymorphic => true
  belongs_to :gifter, :polymorphic => true
  
  validates_presence_of :description
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
end
