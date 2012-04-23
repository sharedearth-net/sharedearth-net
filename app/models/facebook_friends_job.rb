class FacebookFriendsJob < ActiveRecord::Base
  belongs_to :user
  
  def self.week_since_last_run? user
    job = FacebookFriendsJob.where(:user_id => user).first
    return true unless (job.present? && job.updated_at > 7.days.ago)
  end
end