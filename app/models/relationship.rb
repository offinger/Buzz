class Relationship < ActiveRecord::Base
  #In the case of the Relationship model, the followed_id should be accessible,since users will create relationships through the web, but the follower_id attribute should not be accessible; otherwise, malicious users could force other users to follow them.
  
  attr_accessible :followed_id
  
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"
  
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end
